# CheatSheet App Store screenshots

The current set contains ten iPhone screenshots (`iphone-01.png` through
`iphone-10.png`) and ten Mac screenshots (`mac-01.png` through `mac-10.png`).
Upload them in filename order. The iPhone files are 1320 × 2868 pixels for the
6.9-inch display slot. The Mac files are 2880 × 1800 pixels. All are RGB PNGs
without transparency.

The first iPhone image shows the Home Screen widget. The next images show the
note library, editor, checklist, font and text-size controls, search, colors,
reference notes, and Trash recovery. The Mac set shows menu bar quick capture,
varied notes and colors, search, and Trash recovery. Captions and capture sources are
listed in `captions.tsv`.

The iPad files in this directory are from an earlier set. They are outside
this iPhone and Mac update.

## Capture and render

The iPhone UI test target has a dedicated `MarketingScreenshotTests` suite.
It launches the app with `-cheatsheet-seed-screenshot-demo` to show curated
reference notes. Run it on an installed iPhone simulator runtime, then export
the kept attachments and copy them to `AppStoreScreenshots/raw/iphone/` using
the attachment names from `captions.tsv`:

```sh
xcodebuild test -project CheatSheet.xcodeproj -scheme CheatSheetiOSUI \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=<existing 6.9-inch iPhone simulator>,OS=27.0' \
  -resultBundlePath /tmp/CheatSheet-Marketing-Captures.xcresult \
  -only-testing:CheatSheetiOSUITests/MarketingScreenshotTests
xcrun xcresulttool export attachments \
  --path /tmp/CheatSheet-Marketing-Captures.xcresult \
  --output-path /tmp/CheatSheet-Marketing-Attachments
```

The widget source is cropped from the existing
`Docs/Images/cheatsheet-iphone-widget.png` marketing capture.

The Mac sources were captured from the app window and menu bar panel in the
Debug build with the same seeded notes and `-showWidgetHints NO`. The panel
and app window were aligned at their actual screen positions for `mac-02`.
The raw capture directory is
ignored by Git. Once the sources are present, render the final assets with:

```sh
python3 AppStoreScreenshots/templates/render_final.py
```

The renderer uses the approved centered-caption layout and the existing dark
CheatSheet gradient. Captions describe visible features. They are short enough
to read at App Store preview size.
