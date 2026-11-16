# Controller Cycling Mounts

3D-printable mounts that put ordinary game controllers on a bike, so you can
use them for shifting and steering in Zwift on an indoor trainer. They are the
hardware side of [Game Controller for Zwift](https://github.com/VoltageSolutions/GameControllerForZwift),
a Windows app that connects standard game controllers to Zwift.

Every model is **OpenSCAD source**: use it as is, change the settings, or build
your own mounts on the shared rail and cleat code.

**Just want to print?** Download the STL/3MF files from the
[latest release](../../releases/latest).

## Mounts

### Nintendo Joy-Con (original Switch)

Start with the [Joy-Con guide](joycon/): print the two fit tests first.

| | Mount | Attaches to | Status |
| --- | --- | --- | --- |
| ![](joycon/garmin-grip/images/grip_top.png) | [**Garmin grip**](joycon/garmin-grip/): both Joy-Cons in one gamepad-style grip | Any Garmin quarter-turn mount (out-front, stem) | Ready: rail and cleat fit tests passed |
| ![](joycon/handlebar-mount/images/preview_iso.png) | [**Handlebar mount**](joycon/handlebar-mount/): one Joy-Con per side (print two), like Zwift Play | Strapped to the bar tops with zip ties | Prototype |

## Download or build

- **Ready-to-print files:** each [release](../../releases) has STL and 3MF
  files for every mount, already oriented for printing, plus single-file
  `.scad` versions for MakerWorld's customizer.
- **Customize in OpenSCAD** (2021.01 or newer):
  1. Clone or download the whole repo. The models load the shared code from
     `lib/` and `assets/` by relative path, so keep the folders together.
  2. Open a mount's `.scad` file, then **Window → Customizer** to change
     settings.
  3. **F6** to render, then **File → Export**.
- **Build everything:** `tools/build.sh` writes all STL/3MF files to `build/`
  and refreshes the preview images. `tools/bundle.py --all` writes the
  single-file versions. Both need `openscad` on your PATH.

## Repo layout

```
joycon/              Nintendo Joy-Con (original Switch)
  fit-tests/           Rail and Garmin cleat tests: print these first
  garmin-grip/         Two Joy-Cons on a Garmin quarter-turn cleat
  handlebar-mount/     One Joy-Con per side, clamped to the bar
lib/                 Shared OpenSCAD code (Joy-Con rail, Garmin cleat)
assets/              Logo SVG
docs/                Design notes and measured dimensions
tools/               build.sh, bundle.py, and targets.txt
.github/workflows/   CI builds every model on pull requests; merges to main release
```

Each mount folder has its `.scad` source, a README, and preview images. STL and
3MF files are build output: they are not committed, they are attached to
releases.

## Releases

The version lives in the `VERSION` file. Merging a pull request into `main`
with a new version builds every model and publishes a GitHub Release with all
the STL/3MF files. Pull requests only build, as a check. Details in
[CONTRIBUTING.md](CONTRIBUTING.md).

## Contributing and support

Fit reports, problem reports, ideas, and pull requests are welcome. See
[CONTRIBUTING.md](CONTRIBUTING.md) for what to include and how changes are
built and released, and please follow the [Code of Conduct](CODE_OF_CONDUCT.md).

### Donate

Support this project on [ko-fi](https://ko-fi.com/voltagesolutions)!

## License

Copyright © 2026 Voltage Solutions LLC.

[CC BY-SA 4.0](LICENSE.md): you may use, change, print, and share these
designs, as long as you credit this project and share your changed versions
under the same license.

The VOLTAGE wordmark (`assets/voltage_wordmark.svg`, and the logo recessed into
some designs) is a trademark of Voltage Solutions LLC and is not covered by
this license. If you share your own version of a design, set
`logo = false` in the Customizer or replace `logo_file` with your own logo.

This is an AI-assisted project, leveraging support from Anthropic's Claude.
