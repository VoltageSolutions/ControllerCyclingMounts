// ============================================================
// Joy-Con rail test print  (ControllerCyclingMounts)
// A 25 mm piece of the Switch (1) Joy-Con rail used by every
// Joy-Con mount in this repo. Print it before a full mount to check
// your printer's tolerances. ~5 g, ~15 min.
//
// Print: as exported (standing up, channel vertical). No supports.
//        Same orientation as the full mounts.
//
// What to check:
//   - The Joy-Con slides in from the flared end with light, even
//     friction (no wobble, no forcing).
//   - Its latch clicks into the notch about 10-15 mm in, and the
//     release button lets it slide back out.
//   Too tight: lower your flow / check elephant foot at the entrance.
//   Too loose: raise flow slightly. The profile is in ../lib/joycon_rail.scad.
// ============================================================
use <../../lib/joycon_rail.scad>

/* [Test piece] */
length  = 25;   // mm of rail
block_w = 15;   // material behind the rail face

joycon_rail_test(len = length, block_w = block_w);
