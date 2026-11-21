#!/usr/bin/env bash
# Build every target in tools/targets.txt: STL / 3MF exports and PNG previews.
#
# Usage:
#   tools/build.sh                # build everything
#   tools/build.sh grip           # only targets whose line contains "grip"
#   OPENSCAD=/path/to/openscad tools/build.sh
#   NO_IMAGES=1 tools/build.sh    # skip PNG previews (used by CI)
#
# STL/3MF go to build/ (git-ignored); PNGs go to <design>/images/.
# Works from any directory. Stops on the first OpenSCAD warning or error.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/tools/targets.txt"
OPENSCAD="${OPENSCAD:-openscad}"
FILTER="${1:-}"
IMGSIZE="${IMGSIZE:-1200,900}"
BUILD="${BUILD_DIR:-$ROOT/build}"
NO_IMAGES="${NO_IMAGES:-}"

command -v "$OPENSCAD" >/dev/null || { echo "error: openscad not found (set OPENSCAD=...)" >&2; exit 1; }

# PNG export needs a display on headless Linux.
PNG_WRAP=()
if [[ -z "${DISPLAY:-}" && "$(uname -s)" == "Linux" ]] && command -v xvfb-run >/dev/null; then
    PNG_WRAP=(xvfb-run -a)
fi

trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; s="${s%"${s##*[![:space:]]}"}"; printf '%s' "$s"; }

run_openscad() {   # args: log-label, openscad args...
    local label="$1"; shift
    local log; log="$(mktemp)"
    if ! "$@" >"$log" 2>&1; then
        echo "FAILED: $label" >&2; cat "$log" >&2; rm -f "$log"; exit 1
    fi
    if grep -qE "WARNING|ERROR" "$log"; then
        echo "FAILED (warnings): $label" >&2; cat "$log" >&2; rm -f "$log"; exit 1
    fi
    rm -f "$log"
}

count=0
while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$(trim "$line")" || "$(trim "$line")" == \#* ]] && continue
    [[ -n "$FILTER" && "$line" != *"$FILTER"* ]] && continue

    IFS='|' read -r scad base outputs defines camera mode <<<"$line"
    scad="$(trim "$scad")"; base="$(trim "$base")"; outputs="$(trim "$outputs")"
    defines="$(trim "${defines:-}")"; camera="$(trim "${camera:-}")"
    mode="$(trim "${mode:-}")"; mode="${mode:-render}"

    src="$ROOT/$scad"
    [[ -f "$src" ]] || { echo "error: missing $scad" >&2; exit 1; }
    dir="$(dirname "$src")"

    dargs=()
    if [[ -n "$defines" ]]; then
        IFS=';' read -ra kv <<<"$defines"
        for d in "${kv[@]}"; do d="$(trim "$d")"; [[ -n "$d" ]] && dargs+=(-D "$d"); done
    fi

    IFS=',' read -ra outs <<<"$outputs"
    for o in "${outs[@]}"; do
        o="$(trim "$o")"
        case "$o" in
            stl|3mf)
                mkdir -p "$BUILD"
                out="$BUILD/$base.$o"
                echo "  $scad -> ${out#$ROOT/}"
                run_openscad "$out" "$OPENSCAD" --hardwarnings "${dargs[@]}" -o "$out" "$src"
                ;;
            png)
                [[ -n "$NO_IMAGES" ]] && continue
                mkdir -p "$dir/images"
                out="$dir/images/$base.png"
                cam=(--autocenter --viewall)
                [[ -n "$camera" ]] && cam=(--camera="$camera" --autocenter --viewall)
                echo "  $scad -> ${out#$ROOT/}"
                # "render" = full geometry (accurate); "preview" keeps colours
                # (e.g. stand-in Joy-Cons) but can show z-fighting on cut faces.
                ropt=(); [[ "$mode" == "render" ]] && ropt=(--render)
                run_openscad "$out" "${PNG_WRAP[@]}" "$OPENSCAD" --hardwarnings "${ropt[@]}" "${dargs[@]}" \
                    "${cam[@]}" --imgsize="$IMGSIZE" --colorscheme=Tomorrow -o "$out" "$src"
                ;;
            *) echo "error: unknown output '$o' in: $line" >&2; exit 1 ;;
        esac
        count=$((count + 1))
    done
done <"$MANIFEST"

echo "Built $count file(s)."
