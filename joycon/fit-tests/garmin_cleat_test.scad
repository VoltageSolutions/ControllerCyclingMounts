// ============================================================
// Garmin quarter-turn cleat test print  (ControllerCyclingMounts)
// The male quarter-turn cleat used by the Garmin-compatible mounts
// in this repo, on a small plate. Print it and try it in your
// Garmin / Wahoo / other quarter-turn mount before a full mount.
//
// Print: as exported. The default stands the plate up so the cleat
//        prints sideways, exactly as it does on the Joy-Con grip.
//        No supports. Set standing = false for a flat version.
//
// What to check:
//   - The cleat drops into the mount rotated 90 degrees.
//   - It twists a quarter turn with firm, smooth resistance and
//     clicks when straight (springs drop into the grooves).
//   - Once locked it doesn't rattle or lift out.
//   Won't twist: clean any strings/sag under the lugs; if still
//     tight, raise neck_h in ../lib/garmin_cleat.scad by 0.1-0.2.
//   Loose / rattles: lower neck_h by 0.1.
// ============================================================
use <../../lib/garmin_cleat.scad>

/* [Test piece] */
standing = true;   // true = print like the grip does (recommended)
angle    = 0;      // lug direction

garmin_cleat_test(standing = standing, angle = angle);
