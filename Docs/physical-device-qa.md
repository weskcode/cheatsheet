# Physical-device QA for CheatSheet 1.2

Do not resubmit until the final candidate passes the checks below and the
physical-device recording is attached or linked in App Review Information.
Simulator checks supplement physical-device testing; they do not replace it.

## Gates identified in the build 42 audit

- Physical UI testing needs a development team on `CheatSheetiOSUITests` and
  development profiles that include the designated devices. The connected
  iPhone SE already has matching local development profiles; no registration
  or profile refresh is needed for that device. The approved test-target team
  setting is now configured; its signed physical-device test build passed.
- The app includes TelemetryDeck with initialization and signals disabled.
  Its app privacy manifest now declares no collected data. The bundled SDK
  retains its own Product Interaction and Device ID declarations for Analytics;
  the aggregate archive report will therefore still include those SDK types.
  AppHQ policy publication is approved but awaits authenticated editor access.
- Settings now includes the approved separate Privacy Policy row, localized
  in English and Spanish. Runtime link and browser-handoff checks are pending.
- Read-only App Store Connect checks on 2026-11-03 confirmed published
  Data Not Collected privacy answers and active required agreements. Recheck
  them against the final candidate; EU trader status remains unverified.
- Uploaded screenshots include the old inline appearance controls. Refresh
  the affected assets before submitting a build with the Style presentation.
- The physical-device recording has not been produced. Do not label simulator
  evidence or a development build as a recording of the submitted candidate.

Recheck these gates against the final candidate; this list records the audit
state, not authorization to change signing, privacy, or release configuration.

## Devices and data safety

- Use an iPhone and an iPad for the primary pass. Add an iPhone SE for compact
  screen coverage if it runs a supported OS.
- Record each model, OS version, installed app version/build, and result.
- Use the latest public OS for Apple's demonstration. Verify that version
  before recording; a simulator or beta OS is not a substitute.
- Preserve existing notes. Do not uninstall the app, clear its container, or
  reset a device. Use disposable notes for Trash and deletion checks.
- Existing UI tests select an in-memory note store. They still change app
  preferences, including onboarding and widget hints. Run them only on a
  designated QA installation after recording the original onboarding state
  (`hasCompletedOnboarding`) and widget hint preference (`showWidgetHints`).
  After a failed run, restore Show widget setup hint to its recorded value.
  UI-test launches can mark onboarding complete; verify its intended state
  before a normal-app pass or review recording.
- UI-test mode cannot prove disk persistence or the installed widget's shared
  App Group data. Test those using the normal app, without test launch arguments.
- Do not copy real note contents into screenshots, logs, or review evidence.

## Prepare automation

Run from an isolated checkout outside File Provider-managed storage. Read the
workspace's runtime and signing rules first. Do not download runtimes, register
devices, change signing, or refresh provisioning without the required approval.

```sh
git status --short
xcode-select -p
xcrun devicectl list devices
xcrun simctl runtime list
Scripts/verify-project-config.sh
Scripts/verify-localization.sh
Scripts/verify-build-sdk.sh
xcodegen generate --spec project.yml
mkdir -p CheatSheet.xcodeproj/project.xcworkspace/xcshareddata/swiftpm
cp ci_scripts/Package.resolved CheatSheet.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
xcodebuild -showdestinations -project CheatSheet.xcodeproj -scheme CheatSheetiOSUI -disableAutomaticPackageResolution -onlyUsePackageVersionsFromResolvedFile
```

Select the exact destination reported by Xcode. Use an existing iOS 27+
simulator under the current local policy, or an approved physical QA device.
The app's deployment floor remains iOS 26.0. A missing destination blocks its
check; do not install an older simulator runtime to satisfy it.
If the SDK check fails, pause submission preparation and report the mismatch;
do not install another Xcode or runtime as an automatic repair.

After signing approval and profile preparation, run the existing UI suite on
the physical device. Set `qa_destination` to `platform=iOS,id=<DEVICE_UDID>`;
do not use the literal placeholder. This command does not request provisioning
updates or device registration.

```sh
qa_destination='platform=iOS,id=<DEVICE_UDID>'
qa_results=$(mktemp -d /private/tmp/CheatSheet-DeviceQA.XXXXXX)
xcodebuild test \
  -project CheatSheet.xcodeproj \
  -scheme CheatSheetiOSUI \
  -destination "$qa_destination" \
  -derivedDataPath "$qa_results/DerivedData" \
  -resultBundlePath "$qa_results/UI.xcresult" \
  -parallel-testing-enabled NO \
  -disableAutomaticPackageResolution \
  -onlyUsePackageVersionsFromResolvedFile \
  -only-testing:CheatSheetiOSUITests/CheatSheetiOSUITests \
  -only-testing:CheatSheetiOSUITests/CheatSheetiOSSpanishLocaleUITests \
  > "$qa_results/UI.log" 2>&1
xcrun xcresulttool get test-results summary --path "$qa_results/UI.xcresult" --format json
```

Inspect the command's exit status and log even if a summary cannot be opened.
Retain the `.xcresult`, log, source SHA, and any tested uncommitted diff. The
hostless `CheatSheetiOSTests` unit target cannot run on physical devices; keep
unit tests on Mac/simulator rather than silently changing its host settings.
At most two build/test lanes may run, each using its own device and DerivedData.

## Normal-app checks on each physical device

| Area | Expected result |
| --- | --- |
| Launch and onboarding | Launch completes; onboarding dismisses and stays dismissed on subsequent launches. |
| Capture and search | New notes open for editing; title/body searches find matching notes and clear correctly. |
| Input edge cases | Empty notes, long titles, long unbroken text, emoji, multiline paste, and rapid edits remain usable. |
| Formatting and style | Open Style; check every color/font option and text size, close and reopen it, then resume plain-text editing. Repeat in landscape, including opening a size menu and using Done. Headings and unchecked/completed items render as intended. |
| Settings | Widget hint changes persist; requesting onboarding shows it on the next launch only until dismissed. |
| Persistence | Changes survive backgrounding and normal relaunch without test arguments. Check offline too. |
| Trash | Disposable notes restore; confirmed permanent deletion removes only the intended note. |
| Navigation | Search, editor, Settings, and Trash have working return paths with the keyboard shown or dismissed. |
| iPad | Portrait/landscape, supported window sizes, sidebar/detail selection, and hardware keyboard remain usable. |
| Accessibility | Large and accessibility text sizes, VoiceOver labels/order/actions, contrast, and Reduce Motion remain usable. |
| Localization | English and Spanish show readable, translated controls, onboarding, dates, errors, and widgets. |
| Stability | Repeated launch/edit/background cycles produce no crash, hang, or lost edits. |

Do not simulate storage corruption, advance the device clock to expire Trash,
or force disk exhaustion on a device with personal data. Those cases belong in
isolated repository tests. Record any real failure without exposing note text.

## Home Screen widgets

Test small, medium, and large widgets on both platforms where supported:

1. Pin a disposable note in the normal app, then add the widget through the
   system picker. Confirm its content, color, and font.
2. Edit the pinned note and allow the system to refresh. Record the observed
   timing; WidgetKit scheduling does not promise an immediate update.
3. Pin another note. Confirm that the widget follows the selected note and
   does not display stale content after subsequent refreshes.
4. Move the pinned note to Trash, restore it, then delete only disposable
   content. Check the displayed state against the app's current selection.
5. Check empty/no-active-note behavior using only a designated installation
   containing disposable data. Do not delete personal notes to create it.
6. Check long content, appearance changes, supported text sizes, and tapping
   the widget. Record actual navigation; do not assume note-specific deep links.

Use the Device panel's `device_open` launcher for interactive automation and
captures when supported. If physical control or a widget action is unavailable,
record the exact human check as pending. A pin-button test is not widget proof.

## App Review recording and release gate

Use the actual final TestFlight candidate on physical hardware. Start recording
on the Home Screen, launch CheatSheet, and demonstrate creating/editing a note,
formatting/style controls, search, pinning, the real Home Screen widget, Settings,
and Trash/restore with disposable content. Do not use simulator captures or
curated screenshot mode as evidence of a physical-device run.

Before resubmission, verify all six requested review-note answers, recording
access, build identity, current screenshots, live privacy policy, in-app policy
access, privacy declarations, and App Privacy publication. First-release iOS
version 1.2 has no editable What's New field; leave it blank.

The iOS app record is `6784109231`. Keep all queries scoped to `IOS`; the Mac
submission is separate. These commands inspect readiness without submitting:

```sh
asc versions list --app 6784109231 --version 1.2 --platform IOS --include build
asc review doctor --app 6784109231 --version 1.2 --platform IOS
asc validate --app 6784109231 --version 1.2 --platform IOS --check-urls
```

Re-resolve the review-detail ID for the final version before uploading a
recording with `asc review attachments-upload --review-detail <ID> --file <FILE>`.
Read back its attachment delivery state and verify playback/access. Do not
attach simulator evidence under a physical-device label. An expired Apple web
session leaves App Privacy publication and required agreements unverified even
when the public API validator finds no blocking errors.

Track each case as PASS, FAIL, BLOCKED, or NOT RUN with its evidence and tested
build. A build alone does not pass a user flow. No required physical check or
independent review may remain pending when declaring the candidate VERIFIED.
Resubmission, release, and any uncovered signing/privacy/publication actions
still require named approval.
