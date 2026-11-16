// ============================================================
// Nintendo Switch (1) Joy-Con female rail
// Part of ControllerCyclingMounts.  Use with:  use <../../lib/joycon_rail.scad>
//
// Profile measured from the community "Joycon Grip w/ Front Look LED
// Window" model and confirmed by test print (fits Switch 1 Joy-Cons).
// NOT compatible with Joy-Con 2 (magnetic attachment).
//
// Local frame for all modules here:
//   rail face at x = 0, material at x < 0
//   rail runs along +Y; the open end (where the Joy-Con's shoulder
//   end ends up) is at y = len, the closed end at y = 0
//   z = 0 is the rail centreline (Joy-Con is ~14 mm thick, centred)
// ============================================================

JC_SLOT_W   = 7.40;  // opening between the two lips
JC_LIP_T    = 0.62;  // lip thickness
JC_INNER_W  = 10.0;  // height of the undercut cavity
JC_INNER_D  = 2.58;  // depth of the cavity behind the lips
JC_RAIL_LEN = 92.5;  // channel length; the Joy-Con bottoms out at the end
JC_BODY_T   = 14;    // Joy-Con thickness at the rail

// Total depth of the channel below the rail face
function joycon_rail_depth() = JC_LIP_T + JC_INNER_D;

// Subtract this from a solid. The channel starts at y = len - rail_len
// and is open past y = len.
//   lead_in     flare at the entrance
//   notch_*     latch notches (cut into both lips)
//   end_slope   closed end sloped (x this many channel depths) so it
//               prints without bridging when the rail stands vertically
//   open_both_ends  for short test pieces
module joycon_rail_channel(len = JC_RAIL_LEN, rail_len = JC_RAIL_LEN,
                           lead_in = 0.6, notch_from = 10.0, notch_len = 5.5,
                           end_slope = 2, open_both_ends = false) {
    eps = 0.01;
    y0 = len - rail_len;
    cd = JC_LIP_T + JC_INNER_D;
    ext = open_both_ends ? 1 : 0;
    translate([-cd, y0 - ext, -JC_INNER_W/2]) cube([JC_INNER_D, rail_len + 1 + ext, JC_INNER_W]);
    translate([-JC_LIP_T - eps, y0 - ext, -JC_SLOT_W/2]) cube([JC_LIP_T + 1, rail_len + 1 + ext, JC_SLOT_W]);
    if (!open_both_ends && end_slope > 0)
        hull() {
            translate([-cd, y0, -JC_INNER_W/2]) cube([cd + 1, eps, JC_INNER_W]);
            translate([0, y0 - end_slope * cd, -JC_INNER_W/2]) cube([1, eps, JC_INNER_W]);
        }
    // entrance flare(s)
    for (e = open_both_ends ? [0, 1] : [0])
        translate([0, e == 0 ? len : y0, 0]) mirror([0, e == 0 ? 0 : 1, 0])
            hull() {
                translate([-cd - lead_in, -eps, -JC_INNER_W/2 - lead_in])
                    cube([cd + lead_in + 1, 1, JC_INNER_W + 2 * lead_in]);
                translate([-cd, -3, -JC_INNER_W/2]) cube([cd + 1, eps, JC_INNER_W]);
            }
    // latch notches in both lips
    nd = (JC_INNER_W - JC_SLOT_W) / 2;
    for (s = [-1, 1])
        translate([-JC_LIP_T - 0.3, len - notch_from - notch_len,
                   s < 0 ? -JC_INNER_W/2 : JC_SLOT_W/2 - eps])
            cube([JC_LIP_T + 1, notch_len, nd + eps]);
}

// Short piece of rail for checking fit on your printer.
// Printed standing up (channel vertical), the way the full mounts print.
module joycon_rail_test(len = 25, block_w = 15, block_t = JC_BODY_T) {
    rotate([-90, 0, 0]) translate([0, -len, 0]) difference() {
        translate([-block_w, 0, -block_t/2]) cube([block_w, len, block_t]);
        joycon_rail_channel(len = len, rail_len = len, open_both_ends = true);
    }
}
