// ============================================================
// Joy-Con Handlebar Mount (direct to bar, "Zwift Play" position)
// Holds ONE Nintendo Switch (1) Joy-Con just inboard of the hood,
// face up, long axis pointing forward, its rail facing outboard
// toward the hood. The mount clamps onto the bar tops near the bend
// and a rail beam runs forward from the clamp.
//
//   side = "left"  -> mounts on the LEFT bar, holds the RIGHT Joy-Con
//   side = "right" -> mounts on the RIGHT bar, holds the LEFT Joy-Con
//
// Orientation (as mounted, rider's view):
//   +X = toward the stem (inboard) on the left bar
//   +Y = forward, +Z = up
//   The bar tops run along X through the origin.
//   The Joy-Con slides in from the FRONT and bottoms out at the
//   closed end of the rail, near the clamp.
//   Pitch is set by rotating the clamp on the bar before tightening.
//
// Clamp styles:
//   "strap" one-piece saddle; hold it on with zip ties, velcro or
//           Garmin-style rubber O-rings through the two strap channels
//   "bolt"  two-piece split clamp, 2x M4 bolts + nuts (side-loaded
//           nut slots); optional printed TPU shim for smaller bars
//
// Print: the mount stands on the FRONT end of the rail beam, so the
//        rail runs vertically (like the grip) and nothing floats.
//        Use a brim (8-10 mm) - it is tall and narrow. No supports.
//        The bolt cap and TPU shim print standing on an end face.
//        PETG/ASA recommended; 4+ walls, 30%+ infill.
//
// Part of ControllerCyclingMounts. Rail comes from ../../lib.
// NOT for Joy-Con 2 (magnetic attachment).
// ============================================================

use <../../lib/joycon_rail.scad>

/* [What to render] */
part = "mount"; // [mount, cap, shim, preview]
side = "left";  // [left, right]
clamp_style = "strap"; // [strap, bolt]
print_orient = true;   // orient the part for printing

/* [Handlebar] */
bar_d        = 27;   // bar diameter WITH tape at the clamp spot (typ. 24-32)
clamp_w      = 25;   // clamp width along the bar (keep it on the straight part)
clamp_wall   = 4;
clamp_x_offset = 0;  // shift the clamp along the bar (- = outboard)

/* [Joy-Con position] */
rail_forward = 0;    // extra gap between bar and Joy-Con (mm)
rail_dz      = 0;    // raise (+) / lower (-) the Joy-Con relative to the bar centre
yaw          = 0;    // deg; + turns the front of the Joy-Con outboard, toward the hood
beam_w       = 8;    // rail beam width (rail depth is 3.2 mm)
end_cap      = 6;    // solid end of the rail behind the Joy-Con
jc_tail      = 7.5;  // how far the Joy-Con body extends behind its rail
jc_clear     = 2;    // clearance between Joy-Con and bar

/* [Strap clamp] */
strap_w      = 5.2;  // channel width (zip tie 4.8, O-ring ~3, narrow velcro 5)
strap_t      = 3.0;  // channel depth
strap_x      = [-11.5, -19.5]; // channel centres, relative to the rail face
liner_t      = 0;    // room for a rubber liner inside the saddle (0 = none)

/* [Bolt clamp] */
bolt_d       = 4.4;  // M4 clearance
nut_af       = 7.3;  // M4 nut across flats + clearance
nut_t        = 3.4;
head_d       = 7.6;  // M4 socket head + clearance
clamp_gap    = 1.0;  // gap between the halves, so the bolts can squeeze
cap_ear_h    = 10;   // ear depth on the cap
shim_t       = 1.0;  // TPU shim thickness: fits a bar 2*shim_t smaller than bar_d

$fn = 72;
eps = 0.01;
T   = 14;            // Joy-Con thickness at the rail
JC_RAIL = 92.5;
CD  = joycon_rail_depth();

Lb  = end_cap + JC_RAIL;                     // beam length
R_in  = bar_d/2 + (clamp_style == "strap" ? 0.25 + liner_t : 0);
R_out = R_in + clamp_wall;
y_closed = bar_d/2 + jc_clear + jc_tail + rail_forward; // closed end of the rail
y_b = y_closed - end_cap;                    // rear of the beam
cx0 = -clamp_w + clamp_x_offset;             // clamp spans x = cx0 .. cx0 + clamp_w
cx1 = cx0 + clamp_w;
z_b = R_in + 3.2;                            // bolt axis distance from bar centre
bolt_x = (cx0 + cx1) / 2;
ear_out = z_b + 6;

// ---------- beam ------------------------------------------------
module beam_place() {
    translate([0, y_b, rail_dz]) rotate([0, 0, yaw]) children();
}

// Beam in its own frame: rail face at x = 0 (facing +X), material x < 0,
// y = 0 (rear) .. Lb (front, open end).  Rail face square, other edges rounded.
module beam_solid(len = Lb) {
    r = 2;
    hull() {
        translate([-eps, 0, -T/2]) cube([eps, len, T]);
        for (z = [-1, 1]) translate([-beam_w + r, 0, z * (T/2 - r)])
            rotate([-90, 0, 0]) cylinder(r = r, h = len, $fn = 24);
    }
}

// ---------- clamp pieces ----------------------------------------
module bar_cyl(r, x0 = cx0, w = clamp_w) {
    translate([x0, 0, 0]) rotate([0, 90, 0]) cylinder(r = r, h = w, $fn = 120);
}

// front half shell (y >= y0)
module front_shell(y0) {
    intersection() {
        bar_cyl(R_out);
        translate([cx0 - 1, y0, -R_out - 1]) cube([clamp_w + 2, R_out + 1, 2 * R_out + 2]);
    }
}

// arc of the shell within +-a deg of straight ahead (for the hull)
module front_arc(a = 50) {
    intersection() {
        bar_cyl(R_out);
        translate([cx0, 0, 0]) rotate([90, 0, 90]) linear_extrude(clamp_w)
            polygon([[0, 0], for (t = [-a : 5 : a]) 3 * R_out * [cos(t), sin(t)]]);  // u = +Y, v = +Z
    }
}

// Solid that connects the shell to the beam. It is a hull, sized so
// every downward-facing surface is <= 45 deg when the mount stands on
// the front of its rail for printing.
gusset_len = max(10, R_out + (clamp_w - beam_w) + 1 - y_b);
module web() {
    hull() {
        front_arc();
        beam_place() beam_solid(len = gusset_len);
        if (clamp_style == "bolt") front_ears();
    }
}

// ears for the bolt clamp, beam half (flat top on the split face;
// the web hull runs from them down to the beam)
module front_ears() {
    for (s = [-1, 1]) mirror([0, 0, s < 0 ? 1 : 0])
        translate([cx0, clamp_gap/2, R_in - 1]) cube([clamp_w, nut_t + 5, ear_out - R_in + 1]);
}

module front_ear_cuts() {
    for (s = [-1, 1]) mirror([0, 0, s < 0 ? 1 : 0]) {
        // bolt hole
        translate([bolt_x, -1, z_b]) rotate([-90, 0, 0]) cylinder(d = bolt_d, h = 30, $fn = 32);
        // side-loaded nut slot
        translate([bolt_x - nut_af/2, clamp_gap/2 + 2.5, z_b - nut_af * 0.5774])
            cube([nut_af, nut_t, 20]);
    }
}

module cap_body() {
    difference() {
        union() {
            intersection() {
                bar_cyl(R_out);
                translate([cx0 - 1, -R_out - 1, -R_out - 1]) cube([clamp_w + 2, R_out + 1 - clamp_gap/2, 2 * R_out + 2]);
            }
            for (s = [-1, 1]) mirror([0, 0, s < 0 ? 1 : 0])
                translate([cx0, -cap_ear_h, R_in - 1]) cube([clamp_w, cap_ear_h - clamp_gap/2, ear_out - R_in + 1]);
        }
        bar_cyl(R_in, cx0 - 1, clamp_w + 2);
        for (s = [-1, 1]) mirror([0, 0, s < 0 ? 1 : 0]) {
            translate([bolt_x, -cap_ear_h - 1, z_b]) rotate([-90, 0, 0]) cylinder(d = bolt_d, h = cap_ear_h + 2, $fn = 32);
            translate([bolt_x, -cap_ear_h - 1, z_b]) rotate([-90, 0, 0]) cylinder(d = head_d, h = cap_ear_h - 4.5 + 1, $fn = 32);
        }
    }
}

// ---------- the mount (as installed, left bar) --------------------
module mount_left() {
    difference() {
        union() {
            front_shell(clamp_style == "bolt" ? clamp_gap/2 : 0);
            web();
            beam_place() beam_solid();
            if (clamp_style == "bolt") front_ears();
        }
        // the bar
        bar_cyl(R_in, cx0 - 50, clamp_w + 100);
        // nothing behind the bar centre (strap) / the split (bolt)
        translate([cx0 - 60, -100 + (clamp_style == "bolt" ? clamp_gap/2 : 0), -100])
            cube([clamp_w + 120, 100, 200]);
        // rail
        beam_place() joycon_rail_channel(len = Lb, rail_len = JC_RAIL, end_slope = 1);
        // strap channels: a band just outside the shell, all the way round
        if (clamp_style == "strap")
            for (x = strap_x) difference() {
                bar_cyl(R_out + strap_t, x - strap_w/2, strap_w);
                bar_cyl(R_out - eps, x - strap_w/2 - 1, strap_w + 2);
            }
        if (clamp_style == "bolt") front_ear_cuts();
    }
}

module shim() {
    difference() {
        bar_cyl(R_in);
        bar_cyl(R_in - shim_t, cx0 - 1, clamp_w + 2);
        translate([cx0 - 1, -1, 0]) cube([clamp_w + 2, 2, R_out]);   // split
    }
}

module sided() {
    if (side == "right") mirror([1, 0, 0]) children(); else children();
}

// ---------- print orientation -----------------------------------
// Beam vertical, front (open) end of the rail on the bed.
module mount_print() {
    translate([0, 0, Lb]) rotate([-90, 0, 0])
        rotate([0, 0, -yaw]) translate([0, -y_b, -rail_dz]) mount_left();
}
// Clamp axis vertical, standing on an end face.
module axis_up() { rotate([0, 90, 0]) translate([-cx0 - clamp_w, 0, 0]) children(); }

// ---------- preview -----------------------------------------------
module preview() {
    sided() {
        mount_left();
        if (clamp_style == "bolt") color("orange") cap_body();
        // stand-in bar: tops plus the bend toward the hood
        color("dimgray") {
            bar_cyl(bar_d/2, cx0 - 5, 120);
            translate([cx0 - 5, 35, 0]) rotate([0, 0, 180]) rotate_extrude(angle = 90, $fn = 48)
                translate([35, 0]) circle(d = bar_d, $fn = 36);
            translate([cx0 - 40, 35, 0]) rotate([-90, 0, 0]) cylinder(d = bar_d, h = 60);
        }
        // stand-in Joy-Con
        beam_place() color("limegreen", 0.85)
            translate([0, end_cap - jc_tail, -T/2]) cube([35.9, 102, T]);
    }
}

// ---------- dispatch ----------------------------------------------
if (part == "mount") {
    if (print_orient) sided() mount_print(); else sided() mount_left();
}
else if (part == "cap") {
    if (print_orient) axis_up() cap_body(); else sided() cap_body();
}
else if (part == "shim") {
    if (print_orient) axis_up() shim(); else sided() shim();
}
else if (part == "preview") preview();
