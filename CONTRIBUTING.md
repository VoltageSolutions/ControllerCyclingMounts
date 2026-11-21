# Contributing

Thank you for helping. Fit reports, problem reports, ideas, and pull requests
are all welcome.

## Fit reports, problems, and ideas

Post to the [Issues page](https://github.com/VoltageSolutions/ControllerCyclingMounts/issues).

- **Fit reports** are the most useful thing you can send, good or bad. Include
  your printer, nozzle size, material, slicer profile, which file you printed,
  and any Customizer settings you changed. A photo helps.
- **Something wrong with a part?** A part that won't print cleanly, doesn't
  fit the controller, or doesn't assemble or work the way its README says is
  a problem report. Include the same details as a fit report, plus what went
  wrong, and a photo if you can.
- **Doesn't fit your bike or mount?** Name the mount (brand and model) and,
  for the Garmin grip, the two measurements described in
  [Fit it to your bike mount](joycon/garmin-grip/README.md#fit-it-to-your-bike-mount-check-before-printing).
- **A new controller or mount idea?** Describe the controller and where you'd
  like it on the bike. Photos of your cockpit help a lot.

## Changing or adding a model

Everything here is OpenSCAD source (2021.01 or newer). STL and 3MF files are
build output and are not committed.

- **Layout:** one top-level folder per controller (`joycon/`), one folder per
  mount inside it, each with its `.scad` file, a `README.md` and an `images/`
  folder. Fit tests go in the controller's `fit-tests/` folder.
- **Shared geometry** (rails, cleats, clamps) goes in `lib/`, with a clear
  local coordinate frame described at the top of the file.
- **Settings** go at the top of the design file in Customizer sections, with a
  short comment on each.
- **Printability:** export in the orientation it should print in, with no
  supports needed. Say how it prints in the file header and the README.
- **Build list:** add every printable part to `tools/targets.txt` so it is
  included in releases.
- **Check your change:** run `tools/build.sh` (or `tools/build.sh <filter>`).
  It must finish with no OpenSCAD warnings, and it refreshes the preview
  images, which you should commit.
- **No third-party meshes.** Measure and model instead.

## Branches, versions, and releases

- `main` always matches the latest release.
- Work on a branch and open a pull request against `main`.
- The version lives in one place: the `VERSION` file. A pull request into
  `main` must raise it above the latest release; the Version Check enforces
  this.
- Merging to `main` builds every model and publishes a GitHub Release
  (`vX.Y.Z`) with all the STL/3MF files attached. Pull requests only build;
  they never publish.

## What a pull request needs

CI runs on every pull request: every model must build with no warnings. If
you change how a mount fits, prints, or is assembled, update its README too.

## License

By contributing, you agree that your contribution is licensed under
[CC BY-SA 4.0](LICENSE.md), like the rest of the project. The VOLTAGE wordmark is
a trademark of Voltage Solutions LLC and is not part of that license; please
don't add other logos or trademarks to the designs.

Please follow the [Code of Conduct](CODE_OF_CONDUCT.md).
