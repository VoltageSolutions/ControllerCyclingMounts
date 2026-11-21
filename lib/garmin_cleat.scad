// ============================================================
// Garmin-style quarter-turn cleat (male, "device side")
// Part of ControllerCyclingMounts.  Use with:  use <../../lib/garmin_cleat.scad>
//
// Fit-tested on a Garmin-compatible quarter-turn mount: drops in,
// twists a quarter turn, and clicks. Dimensions: docs/design-notes.md.
//
// Built pointing up (+Z) from z = 0, which is the surface it sits on.
// Lugs lie along X when angle = 0.
//
// v2 changes (after the first test print would drop in but not twist):
//   - lug undersides are chamfered: the gap for the mount's lip is
//     neck_h (1.5) at the neck and neck_h + lug_chamfer (1.95) at the
//     lug tip. This also removes the flat
//     1.8 mm overhang that sagged when the cleat was printed flat.
//   - the side edges of each lug are chamfered underneath
//     (lug_lead_in) so the mount's lip slides under easily.
//   - lugs are thicker at the root (lug_t 1.85) so the outer face sits
//     3.35 mm above the seat.
// ============================================================

// Outer face height of the cleat above its mounting surface
function garmin_cleat_height(pedestal_h = 1.0, neck_h = 1.5, lug_t = 1.85) =
    pedestal_h + neck_h + lug_t;

module _gc_wedge2d(s, r0, r1, w0, w1) {
    polygon([[s * r0, w0/2], [s * r1, w1/2], [s * r1, -w1/2], [s * r0, -w0/2]]);
}

module garmin_cleat(angle = 0,
                    pedestal_d = 33, pedestal_h = 1.0,   // flat seat for the mount's lip
                    neck_d = 24.9, neck_h = 1.5,         // gap for the mount's lip, at the neck
                    lug_d = 28.6, lug_w = 11.0, lug_t = 1.85,  // lug_t measured at the neck
                    lug_chamfer = 0.45,   // extra gap at the lug tip (underside slope)
                    lug_lead_in = 0.5,    // 45-deg chamfer under each lug's side edges
                    lug_notch_d = 2.5, lug_notch_depth = 0.4,
                    // detent grooves along the lugs (springs click in when locked)
                    groove_r0 = 4, groove_r1 = 12, groove_w0 = 1.0, groove_w1 = 2.8,
                    groove_depth = 1.0, groove_draft = 0.4,
                    // lead-in ramps 90 deg from the lugs (springs sit here on insert)
                    ramp_r0 = 5, ramp_drop = 1.0, ramp_half_angle = 55) {
    eps = 0.01;
    z_lug = pedestal_h + neck_h;          // lug underside at the neck
    zt = z_lug + lug_t;                   // outer face
    r_n = neck_d / 2;
    r_l = lug_d / 2;
    difference() {
        union() {
            cylinder(d = pedestal_d, h = pedestal_h + eps, $fn = 96);
            translate([0, 0, pedestal_h]) cylinder(d = neck_d, h = neck_h + eps, $fn = 96);
            translate([0, 0, z_lug]) {
                cylinder(d = neck_d, h = lug_t, $fn = 96);
                rotate([0, 0, angle]) intersection() {
                    cylinder(d = lug_d, h = lug_t, $fn = 96);
                    // lug strip with chamfered lower side edges
                    rotate([90, 0, 90]) translate([0, 0, -r_l - 1])
                        linear_extrude(lug_d + 2)
                            polygon([[-lug_w/2 + lug_lead_in, 0], [lug_w/2 - lug_lead_in, 0],
                                     [lug_w/2, lug_lead_in], [lug_w/2, lug_t],
                                     [-lug_w/2, lug_t], [-lug_w/2, lug_lead_in]]);
                }
            }
        }
        // sloped lug underside: gap grows from neck_h at the neck to
        // neck_h + lug_chamfer at the lug tip
        if (lug_chamfer > 0) {
            r_far = r_l + 2;
            z_far = z_lug + lug_chamfer * (r_far - r_n) / (r_l - r_n);
            rotate_extrude($fn = 96)
                polygon([[r_n + 0.02, z_lug - eps], [r_n + 0.02, z_lug], [r_far, z_far], [r_far, z_lug - eps]]);
        }
        rotate([0, 0, angle]) {
            for (s = [-1, 1])
                translate([s * (r_l + lug_notch_d/2 - lug_notch_depth), 0, pedestal_h + neck_h / 2])
                    cylinder(d = lug_notch_d, h = 10, $fn = 32);
            for (s = [-1, 1]) hull() {
                translate([0, 0, zt - groove_depth])
                    linear_extrude(eps) _gc_wedge2d(s, groove_r0, groove_r1, groove_w0, groove_w1);
                translate([0, 0, zt])
                    linear_extrude(1) _gc_wedge2d(s, groove_r0, groove_r1,
                                                  groove_w0 + 2 * groove_draft, groove_w1 + 2 * groove_draft);
            }
            r_far2 = r_l + 2;
            z_far2 = zt - ramp_drop * (r_far2 - ramp_r0) / (r_n - ramp_r0);
            for (s = [-1, 1]) intersection() {
                rotate([0, 0, s * 90]) linear_extrude(zt + 5)
                    polygon([[0, 0],
                             for (a = [-ramp_half_angle : 5 : ramp_half_angle])
                                 r_far2 * 1.5 * [cos(a), sin(a)]]);
                rotate_extrude($fn = 96)
                    polygon([[ramp_r0, zt], [r_far2, z_far2], [r_far2, zt + 1], [ramp_r0, zt + 1]]);
            }
        }
    }
}

// Cleat test piece.
//   standing = true (default): a vertical plate on a foot, so the cleat
//     prints sideways exactly the way it does on the Joy-Con grip
//     (cleat axis horizontal, lugs horizontal). This is the
//     representative test.
//   standing = false: cleat pointing up on a flat 38 mm disc.
module garmin_cleat_test(standing = true, angle = 0) {
    plate_t = 4;
    if (standing) {
        w = 42; h = 42; c = 21;        // plate size, cleat centre height
        foot_d = 22;
        // vertical plate in the XZ plane; cleat sticks out toward -Y
        translate([-w/2, 0, 0]) cube([w, plate_t, h]);
        translate([-w/2, 0, 0]) cube([w, foot_d, 3]);           // foot behind the plate
        for (x = [-w/2 + 1, w/2 - 4])                           // gussets
            translate([x, plate_t - 0.5, 1]) rotate([90, 0, 90])
                linear_extrude(3) polygon([[0, 0], [foot_d - plate_t, 0], [0, 15]]);
        translate([0, 0.01, c]) rotate([90, 0, 0]) garmin_cleat(angle = angle);
    } else {
        translate([0, 0, 2]) garmin_cleat(angle = angle);
        cylinder(d = 38, h = 2.01, $fn = 96);
    }
}
