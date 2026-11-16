# Design notes

Measured reference dimensions, library conventions and lessons learned. The
current defaults live in the library files. This page records where they came
from.

## Coordinate conventions

### `lib/joycon_rail.scad`

- The rail face is the plane **x = 0**. Material is at **x < 0**: subtract
  `joycon_rail_channel()` from a solid whose rail face sits at x = 0.
- The rail runs along **+Y**. The **open end** is at **y = len**. That's where
  the Joy-Con's shoulder (top) end ends up: the Joy-Con slides in rail-first,
  bottom end leading. The closed end is at y = len − rail_len.
- **z = 0** is the rail centreline. The Joy-Con is ~14 mm thick, centred on
  the rail.
- `joycon_rail_depth()` = total depth of the channel below the face (3.2 mm).

### `lib/garmin_cleat.scad`

- Built pointing **+Z** from **z = 0**, the surface it's attached to. To put it
  on an underside, use `mirror([0,0,1])`.
- Lugs lie along **X** when `angle = 0`.
- Order from the surface: pedestal (flat seat for the mount's lip) → neck (the
  gap the lip slides into) → lug layer (center disc + two lugs) → outer face
  with detent grooves and lead-in ramps.

## Joy-Con rail (Switch 1)

Measured from the community *Joycon Grip w/ Front Look LED Window* by
slicing its rail perpendicular to the rail direction. It matched our test
print, which fits well.

| Feature | Value |
| --- | --- |
| Slot opening (between the lips) | 7.40 mm |
| Lip thickness | 0.62 mm |
| Undercut cavity height | 10.0 mm |
| Cavity depth behind the lips | 2.58 mm (3.2 mm total from the face) |
| Channel length (Joy-Con bottoms out) | 92.5 mm |
| Latch notch | both lips, 10.0–15.5 mm from the open end |
| Body thickness around the rail | 14.0 mm, rail centred |

Our first attempt (from the Cuttlephone project) was 7.2 / 0.70 / 9.7 /
2.45 mm and was slightly tight.

## Grip layout

From the same reference grip:

- Each Joy-Con is splayed **15°** outward.
- The rail faces are **40 mm** apart at the converging (shoulder) end.
- Legs are ~15 mm wide. Non-rail edges are rounded to ~4 mm. The rail faces
  stay square.

## Garmin quarter-turn cleat

Three community cleats were measured with top-down height maps and
horizontal slices. *DiTec case + Garmin connection* and *ReverseGarminCustomv2*
use an identical cleat, and *Shiny Allis-Bojo* is within ~0.2 mm of them.

| Feature | DiTEC / Reverse | Shiny Allis-Bojo |
| --- | --- | --- |
| Neck diameter | 24.9 mm | 25.0 mm |
| Gap under the lugs (seat → lug underside) | 1.5 mm at the neck, ~1.95 mm at the tip (underside sloped) | ~1.55 mm, flat |
| Lug tip-to-tip | ~28.6 mm (tips on a 14.3 mm radius) | ~28.2 mm |
| Lug width | ~11 mm | ~11 mm |
| Lug layer thickness | 1.35 mm + 0.45 mm underside slope | 1.7 mm |
| Lug tip notch | ~2.5 mm wide, ~0.4 mm deep | similar |
| Seat (base) diameter | 32.4 mm | 35 mm tapering to 32.2 mm |

**Detents on the outer face.** All the references have both features:

- **Grooves along the lugs:** tapered wedges from r ≈ 4 mm (≈1 mm wide) to
  r ≈ 12 mm (≈2.8 mm wide), ≈1 mm deep. The mount's plastic springs drop in
  here when the cleat is locked straight. That gives the click and holds it.
- **Lead-in ramps 90° from the lugs:** the face slopes down ≈1 mm toward the
  edge over r ≈ 5 → 12.5 mm, in a sector around the axis perpendicular to the
  lugs. The springs rest here when the cleat is first dropped in, then ride up
  the ramp and into the grooves as you twist.

## Lessons learned

- **Rails must print standing up.** When a rail channel lies horizontally, the
  upper lip is an island: for its first ~1.25 mm of height it isn't connected
  to anything below, and slicers flag it as floating. Standing the part up so
  the channel runs vertically (or nearly, like the 15° splayed grip) fixes
  this with no supports. The closed end of the channel is sloped so it doesn't
  need to bridge.
- **A plain disc-and-lugs cleat isn't enough.** Without the detent grooves
  and lead-in ramps, the mount's springs have nothing to catch on: the cleat
  doesn't click or hold.
- **Lug undersides are a critical overhang.** On the first cleat test (printed
  flat), the flat 1.8 mm lug overhang sagged, and the cleat dropped in but
  wouldn't twist. The reference cleats slope the lug underside (more gap at the
  tip), and our mounts print the cleat sideways, so that face is no longer an
  overhang.
- **Test pieces should print the way the real part does**, or a pass doesn't
  carry over to the real part.
- **Mesh references are fine for measuring.** Slicing STL/3MF files
  perpendicular to a feature recovers profiles to ~0.05 mm.
