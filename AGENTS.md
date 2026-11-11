# CheatSheet repository guidance

CheatSheet keeps short coding notes, checklists and command reminders close by.
It is a native SwiftUI app for Mac, iPhone and iPad, with one pinned note shared
with WidgetKit. It works offline with no account. Accounts, sync, collaboration
and a full document editor need a separate product decision.

Read relevant sections of [README.md](README.md) and [CONTRIBUTING.md](CONTRIBUTING.md),
not every document for each task. `CheatSheetApp/` contains app UI,
`CheatSheetWidgets/` contains widgets, `Shared/` contains models and persistence,
and `CheatSheetTests/` contains focused Swift Testing coverage.

- `project.yml` owns project configuration. Regenerate with `xcodegen generate`
  when its inputs change; do not hand-edit or commit the ignored Xcode project.
- Preserve SwiftData records, Trash and recovery behavior, pinned-note semantics,
  and app-group sharing. Ask the maintainer before changing data formats,
  migrations, app groups, signing, entitlements, dependencies or deployment
  targets.
- Add English and neutral Spanish strings to the appropriate app or widget
  String Catalog. Preserve accessibility, semantic text styles and non-color
  state indicators. Widgets and compact, split-view and menu-bar surfaces need
  checks when the changed behavior reaches them.
- The TelemetryDeck SDK is linked but disabled and sends nothing. Do not enable
  or initialize it, and never send note content or identifiers. Ask before any
  analytics or privacy change.
- Keep the iOS and macOS 26.0 deployment floors per
  [the OS support policy](Docs/os-support-policy.md). Do not install runtimes or
  create simulators to satisfy a check; report the check as blocked. An SDK
  mismatch is not permission to change targets or pins.
- `Scripts/verify-project-config.sh` and `Scripts/verify-localization.sh` cover
  configuration and catalogs. README documents native test and build commands
  and `Scripts/verify-macos.sh`; builds do not prove widget or UI flows.
  Documentation-only work needs proofreading and reference checks, without builds.
- Work on a feature or fix branch from `main` and open a pull request, as in
  CONTRIBUTING.md. Keep releases separate. Every push to `main` and every pull
  request against it starts an Xcode Cloud build, so ask before starting one.
