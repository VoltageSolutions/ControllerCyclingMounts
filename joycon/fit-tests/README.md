# Joy-Con fit tests

Two quick prints that check the parts of every mount that have to fit
precisely. Print them in the same material and with the same slicer profile
you'll use for the real mount.

| Test | Checks | Time / material |
| --- | --- | --- |
| `joycon_rail_test.scad` | Joy-Con (Switch 1) rail: slide fit and latch | ~15 min, ~5 g |
| `garmin_cleat_test.scad` | Garmin quarter-turn cleat: twist-in and click | ~20 min, ~6 g |

Ready-to-print files are in the [latest release](../../../../releases/latest), already oriented. Both print without
supports.

## Joy-Con rail test

A 25 mm piece of the rail used by every Joy-Con mount here. It prints
**standing up** (channel vertical), the same way the full mounts print.

**Pass**
- The Joy-Con slides in from the flared end with light, even friction: no
  wobble, no forcing.
- Its latch clicks into the notch about 10–15 mm in. With the release button
  pressed, it slides back out.

**If it fails**

| Symptom | Try |
| --- | --- |
| Hard to start at the entrance only | Elephant's foot: trim the bed-side edge, or enable elephant-foot compensation |
| Tight along the whole length | Lower flow ~2 %. In `lib/joycon_rail.scad`, raise `JC_INNER_D` (+0.1) and/or `JC_SLOT_W` (+0.1) |
| Loose / Joy-Con wobbles | Lower `JC_INNER_D` (−0.1). If it wobbles side to side, lower `JC_INNER_W` (−0.1) |
| Latch doesn't click | Make sure the Joy-Con goes all the way in. The notches are 10–15.5 mm from the open end (`notch_from`, `notch_len` in `joycon_rail_channel()`) |

## Garmin cleat test

The male quarter-turn cleat on a small plate. By default the plate stands up
so the cleat prints sideways, exactly as on the Joy-Con grip
(`standing = false` gives a flat version).

**Pass**
- The cleat drops into your mount turned 90°.
- It twists a quarter turn with firm, smooth resistance and clicks when
  straight (the mount's springs drop into the grooves).
- Once locked it doesn't rattle or lift out.

**If it fails**

| Symptom | Try |
| --- | --- |
| Drops in but won't twist | Check under the lugs for strings or sag and clean them off. If it's still tight, raise `neck_h` in `lib/garmin_cleat.scad` by 0.1–0.2 |
| Won't drop in at all | Lugs too wide: lower `lug_d` (−0.2) or `lug_w` (−0.2) |
| Twists but doesn't click | Deepen the detents: `groove_depth` +0.2 |
| Rattles when locked | Lower `neck_h` by 0.1 |
| Ends up sideways when locked | Set `cleat_angle = 90` in the design file |

## Report your results

Fit reports help everyone. Open an issue with your printer, nozzle, material,
slicer, and any settings you had to change.
