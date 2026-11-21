// ============================================================
// Joy-Con Bike Grip with Garmin Quarter-Turn Mount  (v2)
// Holds two Nintendo Switch (1) Joy-Cons in a splayed "gamepad"
// layout, with a male Garmin quarter-turn cleat underneath so it
// clicks into any Garmin-compatible out-front / stem mount.
//
// Orientation (as mounted on the bike):
//   +Z = up (Joy-Con faces / sticks point up)
//   +Y = forward (Joy-Con shoulder buttons point forward)
//   Joy-Cons slide in from the FRONT (+Y) end of each rail.
//
// Fit tests for the rail and cleat are in ../fit-tests.
//
// Print: the exported "grip" stands on its front end, so the rails
//        run (nearly) vertically and nothing floats. No supports.
//
// Part of ControllerCyclingMounts. Rail and cleat come from ../../lib.
// ============================================================

use <../../lib/joycon_rail.scad>
use <../../lib/garmin_cleat.scad>

/* [What to render] */
part = "grip"; // [grip, logo_inlay, preview, clearance, swing_test]
print_orient = true; // grip only: stand it on its front end for printing

/* [Layout] */
splay_angle   = 15;   // deg each Joy-Con is angled out
front_gap     = 40;   // mm between the two rail faces at the front end
body_t        = 14;   // grip thickness (= Joy-Con thickness at the rail)
leg_w         = 15;   // width of each leg, rail face to inside edge
edge_r        = 4;    // rounding on the non-rail edges
arch          = true; // opening between the legs at the back
arch_corner_r = 6;

/* [Joy-Con rail] */
jc_rail_len   = 92.5;  // channel length; Joy-Con bottoms out at the end
end_cap       = 7.0;   // closed end of the channel

/* [Garmin quarter-turn cleat] */
// standard: cleat near the middle. The grip sits a little closer to the
//           rider. For mounts that hold the computer above the bar.
// aero:     cleat moved toward the back of the grip, so less of it swings
//           toward the bar. For low, aero out-front mounts (e.g. Trek Blendr).
// custom:   use cleat_y_frac below.
mount_style   = "standard"; // [standard, aero, custom]
cleat_y_frac  = 0.55;  // custom only: 0 = back of the grip, 1 = front
cleat_angle   = 0;     // 0 = lugs left/right. Use 90 if it locks in sideways
spacer_h      = 0;     // extra height between the grip and the mount (mm).
                       // Raise it if the grip hits the bar/stem while twisting
pedestal_d    = 33;    // must match the cleat library default

/* [Mount clearance check] */
// Measure your mount (see README) and enter the values. 0 = don't check.
// A: from the centre of the mount's cradle, horizontally back (toward
//    the rider) to the nearest edge of the bar or stem faceplate.
mount_bar_dist   = 0;
// B: how far the top of that bar/faceplate sits ABOVE the cradle's top
//    surface (negative if it sits below).
mount_bar_height = 0;

/* [Logo] */
logo          = true;
logo_file     = "../../assets/voltage_wordmark.svg";
logo_svg_w    = 125.947; // width of the SVG as imported (mm)
logo_svg_h    = 21.282;
logo_w        = 56;     // printed width (thinnest strokes ~0.87 mm at 56)
logo_y_frac   = 0.475;  // position along the grip (0 = rear, 1 = front)
logo_depth    = 1.2;    // recess depth = inlay thickness, so the inlay sits flush
// Inlay: print part = "logo_inlay" in a second colour and glue it into the recess.
inlay_clearance = 0.10; // per side; raise if the letters won't press in
inlay_face_down = false; // false: print face up (iron the top for a smooth face)
                         // true: mirrored, the bed side becomes the visible face

$fn = 64;
eps = 0.01;

L  = jc_rail_len + end_cap;
T  = body_t;
MOUNT_STYLES = [["standard", 0.55], ["aero", 0.30]];
cleat_frac = mount_style == "custom" ? cleat_y_frac
           : MOUNT_STYLES[search([mount_style], MOUNT_STYLES)[0]][1];
cleat_y = L * cleat_frac;

// ---------- spacer and clearance numbers ---------------------
// The spacer flares out at 45 deg toward the grip so it prints sideways
// without supports.
// The flare is capped so it stays inside the grip's underside.
grip_half_w_at_cleat = front_gap/2 + (L - cleat_y) * tan(splay_angle);
spacer_base_d = min(pedestal_d + 2 * spacer_h, 2 * grip_half_w_at_cleat - 10);
assert(cleat_y - max(pedestal_d, spacer_base_d)/2 > 4,
       "cleat position is too far back: the cleat would hang off the back of the grip");

// Corners of the grip outline (x, y) in the bike frame
function leg_pt(side, lx, ly) =
    let(a = splay_angle, px = front_gap/2, dy = ly - L)
    [side * (px + lx * cos(a) - dy * sin(a)), L + lx * sin(a) + dy * cos(a)];
grip_corners = [for (s = [-1, 1]) for (p = [[0, 0], [-leg_w, 0], [0, L], [-leg_w, L]])
                    leg_pt(s, p[0], p[1])];
jc_corners   = [for (s = [-1, 1]) for (p = [[0, L - 100], [35.9, L - 100]])
                    leg_pt(s, p[0], p[1])];
function sweep_r(pts) = max([for (p = pts) norm([p[0], p[1] - cleat_y])]);
// How far toward the rider (toward the bar) a point gets during a quarter
// turn in either direction from its locked position.
function rear_reach(pts) = max([for (p = pts)
    let(v = [p[0], p[1] - cleat_y], r = norm(v), phi = atan2(v[0], -v[1]))
    (abs(phi) <= 90) ? r : r * max(cos(phi - 90), cos(phi + 90), 0)]);
function behind(pts)  = max([for (p = pts) cleat_y - p[1]]);

grip_sweep  = sweep_r(grip_corners);   // full swing radius (grip only)
jc_sweep    = sweep_r(concat(grip_corners, jc_corners));
grip_reach  = rear_reach(grip_corners); // how far back toward the bar it swings
jc_reach    = rear_reach(concat(grip_corners, jc_corners));
grip_behind = behind(grip_corners);    // how far the grip reaches back when locked
jc_behind   = behind(jc_corners);
underside   = spacer_h + 1.0;          // grip underside above the mount's seat (1.0 = pedestal)

echo(str("CLEARANCE: while twisting, the grip swings up to ", round(grip_reach),
         " mm back toward the bar (", round(jc_reach), " mm with Joy-Cons attached). Locked, it reaches ", round(grip_behind),
         " mm behind the cleat (Joy-Cons ", round(jc_behind), " mm). Underside is ",
         underside, " mm above the mount."));
if (mount_bar_dist > 0) {
    blocked = mount_bar_height >= underside;
    if (blocked && mount_bar_dist < grip_behind + 2)
        echo(str("CLEARANCE PROBLEM: the grip hits the bar even when locked. Set spacer_h to at least ",
                 ceil(mount_bar_height - 1.0 + 2), ", or use mount_style = aero."));
    else if (blocked && mount_bar_dist < grip_reach + 2)
        echo(str("CLEARANCE PROBLEM: a rear corner hits the bar while twisting. Set spacer_h to at least ",
                 ceil(mount_bar_height - 1.0 + 2), ", or use mount_style = aero (or a lower custom cleat_y_frac) until the swing toward the bar is under ",
                 mount_bar_dist - 2, " mm."));
    else
        echo("CLEARANCE OK: the empty grip should twist in. Slide the Joy-Cons in after it is locked.");
}

// ---------- placement of one leg ---------------------------
// Local frame: rail face at x=0, material at x<0, y from 0 (rear,
// closed) to L (front, open), z centred. side = +1 right, -1 left.
module place(side) {
    mirror([side < 0 ? 1 : 0, 0, 0])
        translate([front_gap / 2, L, 0])
            rotate([0, 0, splay_angle])
                translate([0, -L, 0])
                    children();
}

// One leg: rail face and front end square, everything else rounded.
module leg() {
    r = edge_r;
    hull() {
        translate([-eps, r, -T/2]) cube([eps, L - r, T]);          // rail face
        translate([-r, r, -T/2]) cylinder(r = r, h = T);            // rear tip, rail side
        for (z = [-1, 1])                                           // rear tip, inner side
            translate([-leg_w + r, r, z * (T/2 - r)]) sphere(r);
        for (z = [-1, 1])                                           // inner edge
            translate([-leg_w + r, L - 1, z * (T/2 - r)])
                rotate([-90, 0, 0]) cylinder(r = r, h = 1);
        translate([-leg_w, L - eps, -T/2]) cube([leg_w, eps, T]);   // front end (bed)
    }
}

// Opening between the legs, as a 2D shape (convex)
module arch2d() {
    apex = cleat_y - max(pedestal_d, spacer_base_d)/2 - 3;
    // inside corners of the legs at y = -20 and y = apex
    function inner(side, y) =
        let(a = splay_angle, px = front_gap/2, lx = -leg_w, ly = y - L)
        [side * (px + lx * cos(a) - ly * sin(a)), L + lx * sin(a) + ly * cos(a)];
    offset(r = arch_corner_r) offset(delta = -arch_corner_r)
        polygon([inner(-1, -20), inner(1, -20), inner(1, apex), inner(-1, apex)]);
}

// Arch cut, with rounded (filleted) top and bottom edges
module arch_cut() {
    r = edge_r; n = 8;
    translate([0, 0, -T]) linear_extrude(2 * T) arch2d();
    for (s = [-1, 1]) mirror([0, 0, s < 0 ? 1 : 0])
        for (i = [0 : n - 1]) hull() for (k = [i, i + 1]) {
            th = 90 * k / n;
            dz = r * sin(th);
            off = r - r * cos(th);
            translate([0, 0, T/2 - r + dz]) linear_extrude(eps + (k == n ? 1 : 0))
                offset(delta = off) arch2d();
        }
}

// ---------- logo ------------------------------------------------
module logo2d() {
    k = logo_w / logo_svg_w;
    scale([k, k]) translate([-logo_svg_w/2, -logo_svg_h/2]) import(logo_file);
}

// ---------- full grip -------------------------------------------
module grip() {
    difference() {
        union() {
            hull() { place(1) leg(); place(-1) leg(); }
            // cleat on the underside
            translate([0, cleat_y, -T/2]) mirror([0, 0, 1]) {
                if (spacer_h > 0)
                    cylinder(d1 = spacer_base_d, d2 = pedestal_d, h = spacer_h + eps, $fn = 96);
                translate([0, 0, spacer_h]) garmin_cleat(angle = cleat_angle);
            }
        }
        place(1) joycon_rail_channel(len = L, rail_len = jc_rail_len);
        place(-1) joycon_rail_channel(len = L, rail_len = jc_rail_len);
        if (arch) arch_cut();
        if (logo)
            translate([0, L * logo_y_frac, T/2 - logo_depth])
                linear_extrude(logo_depth + 1) logo2d();
    }
}

// Inlay letters, flat on the bed, thickness = recess depth
module logo_inlay() {
    mirror([inlay_face_down ? 1 : 0, 0, 0])
        linear_extrude(logo_depth) offset(delta = -inlay_clearance) logo2d();
}

// Preview with stand-in Joy-Cons and the inlay in place (not for printing)
module preview() {
    grip();
    if (logo)
        color("orange") translate([0, L * logo_y_frac, T/2 - logo_depth])
            linear_extrude(logo_depth) offset(delta = -inlay_clearance) logo2d();
    for (s = [1, -1]) place(s)
        color(s > 0 ? "red" : "dodgerblue", 0.8)
            translate([0, L - 102 + 2, -7]) cube([35.9, 102, 14]);
}

// Clearance view: the grip on a stand-in mount, with the circle the grip
// sweeps while twisting and a stand-in bar at your measured position.
module clearance_view() {
    seat_z = -T/2 - underside;          // the mount's top surface
    grip();
    translate([0, cleat_y, seat_z]) {
        color("gray") translate([0, 0, -12]) cylinder(d = 36, h = 12, $fn = 64);   // cradle
        color("yellow", 0.25) cylinder(r = grip_reach, h = 0.4, $fn = 128);       // reach toward the bar
        color("orange", 0.15) translate([0, 0, 0.4]) cylinder(r = jc_reach, h = 0.2, $fn = 128);
        if (mount_bar_dist > 0)
            color("black") translate([0, -mount_bar_dist - 15.9, mount_bar_height - 15.9])
                rotate([0, 90, 0]) cylinder(d = 31.8, h = 300, center = true);    // bar
    }
}

// ---------- swing test ------------------------------------------
// A thin frame in the grip's outline with a plain centring peg where the
// cleat goes (no lugs). Drop the peg into your mount's centre hole and turn
// it a quarter turn each way: if the frame clears, the grip will too.
// Prints flat, peg up. Flip it over to use it.
swing_frame_t = 2.0;   // frame thickness
swing_band    = 5;     // width of the outline band and spokes
swing_peg_d   = 24.0;  // fits loosely in the mount's centre hole

module grip_outline2d() {
    difference() {
        hull() for (p = grip_corners) translate(p) circle(r = 0.5);
        if (arch) arch2d();
    }
}

module swing_test() {
    // frame
    linear_extrude(swing_frame_t) {
        difference() {
            grip_outline2d();
            offset(delta = -swing_band) grip_outline2d();
        }
        intersection() {
            grip_outline2d();
            union() {
                for (p = grip_corners) hull() {
                    translate([0, cleat_y]) circle(d = swing_band);
                    translate(p) circle(d = swing_band);
                }
                translate([0, cleat_y]) circle(d = pedestal_d + 4);
            }
        }
    }
    // pedestal height + centring peg (the real grip sits this high)
    translate([0, cleat_y, swing_frame_t]) {
        cylinder(d = pedestal_d, h = spacer_h + 1.0 + 0.01, $fn = 96);
        translate([0, 0, spacer_h + 1.0]) cylinder(d = swing_peg_d, h = 3, $fn = 96);
    }
}

if (part == "grip") {
    if (print_orient) translate([0, 0, L]) rotate([-90, 0, 0]) grip();
    else grip();
}
else if (part == "logo_inlay") logo_inlay();
else if (part == "preview") preview();
else if (part == "clearance") clearance_view();
else if (part == "swing_test") swing_test();
