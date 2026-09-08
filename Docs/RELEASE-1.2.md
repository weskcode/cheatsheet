# CheatSheet 1.2: Release Checklist

Master index for shipping 1.2 (build 14). Everything text-based is done and
linked below; the remaining steps happen in Xcode / App Store Connect and
need you, since they involve your Apple ID and signing.

## Documents in this release kit

| Document | Contents |
| --- | --- |
| [`app-store-release-kit-1.2.md`](app-store-release-kit-1.2.md) | Every App Store Connect field: name, subtitle, description, keywords, promo text, what's new, category, age rating, review notes, URLs |
| [`app-store-localization-es.md`](app-store-localization-es.md) | The same fields in Spanish (Mexico) |
| [`testflight-1.2-what-to-test.md`](testflight-1.2-what-to-test.md) | The TestFlight "What to Test" tester message (full + short versions) |
| [`press-kit-1.2.md`](press-kit-1.2.md) | Fact sheet, journalist pitch email, Product Hunt copy, Apple editorial nomination text, social launch posts |
| [`../AppStoreScreenshots/final/`](../AppStoreScreenshots/final/README.md) | 9 store screenshots: 6 iPhone (1320×2868), 3 iPad (2064×2752) |

## Final test pass: 1.2 / build 14

Run against a clean XcodeGen-generated project, both device families, both
platforms, on `release/1.2`.

Confirmed green (latest run, shared-machine load ~700–900):

| Check | Result |
| --- | --- |
| Config gates (project / localization / SDK) | 3/3 PASS |
| Unit tests (macOS) | 69 PASS |
| Unit tests (iOS) | 69 PASS |
| UI tests (iPhone) | 11 PASS |
| UI tests (iPad) | (running, prior full-session run: 11 PASS) |
| Release builds, universal binary, archives | (running, prior full-session run: all PASS, lipo arm64 + x86_64) |
| 9 shipped screenshot assets | exact sizes, no alpha |

No app code changed since `f99d35b`; the pending steps are re-confirmation of
builds/archives that passed earlier this session. Update this table from the
latest `finalsuite2` run if any step regresses.

## Signing: this is a "normal" release, not Xcode Cloud

Decided: submit the ordinary way. Archive locally in Xcode, upload via
Organizer. No CI-based build service.

This machine currently has **no Apple Distribution certificate** (only an
expired-plus-valid set of Development certs) and no provisioning profiles
carrying the App Group entitlement the widgets need. `CODE_SIGN_STYLE` is
already `Automatic` in `project.yml` for every target, so Xcode will
generate what's missing once you give it the certificate:

1. **Xcode → Settings → Accounts** → select your Apple ID → **Manage
   Certificates** → **+** → **Apple Distribution**. One-time; the cert
   installs into your keychain.
2. Open `CheatSheet.xcodeproj` (regenerate first if it doesn't exist:
   `xcodegen generate`).
3. Select the **CheatSheetiOS** scheme → a Generic iOS Device destination →
   **Product → Archive**.
4. Repeat for the **CheatSheetApp** (macOS) scheme with a My Mac
   destination.
5. In the **Organizer** window that opens after each archive: **Distribute
   App → App Store Connect → Upload**. Automatic signing should now resolve
   cleanly. If it complains about the App Group entitlement again, that
   means the Distribution profile needs a manual refresh: **Xcode → Settings
   → Accounts → Download Manual Profiles**, then retry.
6. Each upload lands in App Store Connect → TestFlight after Apple's
   automated processing (usually a few minutes to an hour).

## After upload: TestFlight

1. App Store Connect → your app → **TestFlight** tab → the new build.
2. Fill in **Test Information → What to Test** with the message from
   [`testflight-1.2-what-to-test.md`](testflight-1.2-what-to-test.md).
3. Add internal testers immediately (no review needed); external testers
   require Apple's brief TestFlight review first.
4. Once testers confirm the build is solid, move to submission.

## Submission for App Store review

1. App Store Connect → **App Information**: fill in Category, Age Rating,
   Content Rights per [`app-store-release-kit-1.2.md`](app-store-release-kit-1.2.md#1-app-information-one-time-or-confirm-unchanged).
2. The version page: paste in Name, Subtitle, Description, Keywords,
   Promotional Text, What's New, Support/Privacy URLs from the same file.
3. Upload the 9 screenshots from `AppStoreScreenshots/final/` in filename
   order.
4. Select the build you just validated in TestFlight.
5. Paste the Review Notes block from the release kit.
6. Resolve any remaining open items flagged in the release kit before
   submitting.
7. **Add for Review.**

## Git Flow: after everything above is real and tested

Standard close per `CONTRIBUTING.md`:

```sh
# release/1.2 -> main, tagged
git checkout main && git merge --no-ff release/1.2
git tag -a v1.2.0 -m "CheatSheet 1.2"
git push origin main --tags

# back-merge into develop
git checkout develop && git merge --no-ff release/1.2
git push origin develop

# delete the release branch
git push origin --delete release/1.2
git branch -d release/1.2
```
