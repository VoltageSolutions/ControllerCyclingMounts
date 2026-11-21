# Controller Cycling Mounts

This repository contains 3D-printable mounts to attach video game controllers onto a bike. This enables you to use the controllers for virtual shifting and steering in apps like Zwift on an indoor trainer. This is the hardware complement to [Game Controller for Zwift](https://github.com/VoltageSolutions/GameControllerForZwift), my app that connects standard game controllers to Zwift.

Every model is **OpenSCAD source**. You can use it as is, change the settings, or build
your own mounts.

If you just want to print, download the STL/3MF files from the [latest release](../../releases/latest).

## Mounts

### Nintendo Joy-Con (original Switch)

Start with the [Joy-Con guide](joycon/): print the two fit tests first.

| | Mount | Attaches to | Status |
| --- | --- | --- | --- |
| ![](joycon/garmin-grip/images/grip_mounted.jpg) | [**Garmin grip**](joycon/garmin-grip/): both Joy-Cons in one gamepad-style grip | Any Garmin quarter-turn mount (out-front, stem) | Ready: fit tests passed, aero version tested on a bike |

## Download or build

- **Ready-to-print files:** each [release](../../releases) has `STL`, `3MF`, and `scad`
  files for every mount.
- **Customize in OpenSCAD:** make the print fit your needs.
- **Build everything:** `tools/build.sh` writes all STL/3MF files to `build/`
  and refreshes the preview images. `tools/bundle.py --all` writes the
  single-file versions. Both need `openscad` on your PATH.

## Repo layout

```
joycon/              Nintendo Joy-Con (original Switch)
  fit-tests/           Rail and Garmin cleat tests: print these first
  garmin-grip/         Two Joy-Cons on a Garmin quarter-turn cleat
lib/                 Shared OpenSCAD code (Joy-Con rail, Garmin cleat)
assets/              Logo SVG
docs/                Design notes and measured dimensions
tools/               build.sh, bundle.py, and targets.txt
.github/workflows/   CI builds every model on pull requests; merges to main release
```

## Contributing and support

Please provide feedback about model fit! Issues and PRs are welcome. See
[CONTRIBUTING.md](CONTRIBUTING.md) for what to include and how changes are
built and released.

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
