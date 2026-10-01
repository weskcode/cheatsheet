#!/usr/bin/env python3
"""Render the approved centered-caption iPhone and Mac screenshot sets."""

import argparse
import csv
from pathlib import Path

from compose_screenshot import compose_centered


ROOT = Path(__file__).resolve().parents[1]
SIZES = {"iphone": (1320, 2868), "mac": (2880, 1800)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--device", choices=SIZES)
    args = parser.parse_args()
    with (ROOT / "final" / "captions.tsv").open(newline="") as manifest:
        for row in csv.DictReader(manifest, delimiter="\t"):
            device = row["device"]
            if args.device and args.device != device:
                continue
            source = ROOT / "raw" / row["source"]
            output = ROOT / "final" / f"{device}-{row['order']}.png"
            if not source.is_file():
                raise FileNotFoundError(source)
            compose_centered(source, row["caption"].replace("\\n", "\n"),
                             *SIZES[device], output, device)
            print(output)


if __name__ == "__main__":
    main()
