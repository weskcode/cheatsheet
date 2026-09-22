#!/bin/sh
# Xcode Cloud post-clone hook.
#
# CheatSheet.xcodeproj is gitignored (XcodeGen output, regenerated from
# project.yml; see the top of .gitignore). Xcode Cloud clones the repository
# fresh on every build and has no project file at all until this step
# generates one.
#
# Unlike a shared CI runner image carrying several Xcode installs side by
# side, an Xcode Cloud build machine has exactly one active Xcode version:
# whatever the workflow's Environment tab selected. There is nothing to pick
# here, only to verify.
set -e

if ! command -v xcodegen >/dev/null 2>&1; then
    brew install xcodegen
fi

cd "$CI_PRIMARY_REPOSITORY_PATH"
xcodegen generate --spec project.yml --project . --project-root .

# Fail loudly if the workflow's Environment tab picked an SDK major CheatSheet
# does not expect (a beta, or a version this branch has not been updated for),
# rather than silently archiving something that will bounce at App Store
# upload. Override with CHEATSHEET_EXPECTED_SDK_MAJOR as an environment
# variable on the workflow if a branch intentionally targets a different SDK.
Scripts/verify-build-sdk.sh

# Cheap, toolchain-independent checks that used to run before the simulator
# work in the retired GitHub Actions pipeline. Keep failing fast on these
# rather than only finding out after a build and archive have run.
Scripts/verify-project-config.sh

if [ -x Scripts/verify-localization.sh ]; then
    Scripts/verify-localization.sh
fi
