import XCTest

/// Captures App Store screenshots against the curated demo content.
///
/// Deliberately separate from `CheatSheetiOSUITests`: that suite's QA sweep
/// creates a throwaway "QA Sweep Note" with placeholder body text, so every
/// capture after its third checkpoint shows test data. Apple treats
/// placeholder content in a store listing as grounds for rejection, so
/// marketing captures need their own path that only ever shows
/// `ScreenshotDemoContent`.
///
/// Not a correctness gate. It asserts only enough to know a capture is of the
/// screen it claims. CI skips it; run it on demand:
///   xcodebuild test -scheme CheatSheetiOSUI \
///     -only-testing:CheatSheetiOSUITests/MarketingScreenshotTests
@MainActor
final class MarketingScreenshotTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = true   // one awkward state must not cost the rest of the set
    }

    private func launchSeeded(_ extra: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = [
            "-cheatsheet-ui-testing",
            "-cheatsheet-skip-onboarding",
            "-cheatsheet-seed-screenshot-demo",
            "-showWidgetHints", "NO",
            "-AppleLanguages", "(en)", "-AppleLocale", "en_US"
        ] + extra
        app.launch()
        return app
    }

    private func shoot(_ app: XCUIApplication, _ name: String) {
        let a = XCTAttachment(screenshot: app.screenshot())
        a.name = name
        a.lifetime = .keepAlways
        add(a)
    }

    private var isPad: Bool { XCUIApplication().collectionViews["Sidebar"].exists }

    func testCaptureMarketingSet() throws {
        let app = launchSeeded()

        // M1: the library. Real developer reference notes, colour-coded.
        XCTAssertTrue(app.staticTexts["Git Rescue"].waitForExistence(timeout: 20))
        shoot(app, "M1-library")

        // M2: a real note open, with a heading, commands, checkboxes, and monospace text.
        app.staticTexts["Git Rescue"].firstMatch.tap()
        XCTAssertTrue(app.textFields["note-title-field"].waitForExistence(timeout: 15))
        shoot(app, "M2-note-open")

        // Show a different, task-focused note and the editor's full palette.
        let back = app.navigationBars.firstMatch.buttons.firstMatch
        back.tap()
        app.staticTexts["Ship Checklist"].firstMatch.tap()
        XCTAssertTrue(app.textFields["note-title-field"].waitForExistence(timeout: 15))
        shoot(app, "M3-checklist")

        // M4: font menu open over real content.
        let fontPicker = app.buttons["font-style-picker"].firstMatch
        guard fontPicker.waitForExistence(timeout: 10), fontPicker.isHittable else {
            XCTFail("Font picker is unavailable for the marketing capture")
            return
        }
        fontPicker.tap()
        guard app.buttons["Serif"].firstMatch.waitForExistence(timeout: 5) else {
            XCTFail("Font menu did not open for the marketing capture")
            return
        }
        shoot(app, "M4-font-menu")
        // Leave the note on its default Mono rather than mutating it.
        if app.buttons["Mono"].firstMatch.exists { app.buttons["Mono"].firstMatch.tap() }

        let sizePicker = app.buttons["font-size-picker"].firstMatch
        guard sizePicker.waitForExistence(timeout: 5), sizePicker.isHittable else {
            XCTFail("Text size picker is unavailable for the marketing capture")
            return
        }
        sizePicker.tap()
        guard app.buttons["Medium"].firstMatch.waitForExistence(timeout: 5) else {
            XCTFail("Text size menu did not open for the marketing capture")
            return
        }
        shoot(app, "M8-size-menu")
        app.buttons["Medium"].firstMatch.tap()

        // Each note uses a different palette tint and useful sample content.
        for (title, name) in [
            ("Swift Concurrency", "M9-concurrency"),
            ("Docker Cleanup", "M10-docker"),
            ("Xcode Shortcuts", "M11-shortcuts"),
            ("HTTP Status Codes", "M12-http")
        ] {
            if back.waitForExistence(timeout: 5), back.isHittable { back.tap() }
            XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 10))
            app.staticTexts[title].firstMatch.tap()
            XCTAssertTrue(app.textFields["note-title-field"].waitForExistence(timeout: 10))
            shoot(app, name)
        }
    }

    func testCaptureSearch() throws {
        let app = launchSeeded()
        XCTAssertTrue(app.staticTexts["Git Rescue"].waitForExistence(timeout: 20))

        var field = app.searchFields.firstMatch
        if !field.waitForExistence(timeout: 3) {
            app.swipeDown()
            field = app.searchFields.firstMatch
        }
        if !field.waitForExistence(timeout: 3) {
            let sidebar = app.collectionViews["Sidebar"]
            if sidebar.waitForExistence(timeout: 3) { sidebar.swipeDown() }
            field = app.searchFields.firstMatch
        }
        XCTAssertTrue(field.waitForExistence(timeout: 15))
        field.tap()
        XCTAssertTrue(app.keyboards.element.waitForExistence(timeout: 10))
        field.typeText("git")
        _ = app.staticTexts["Git Rescue"].waitForExistence(timeout: 10)
        shoot(app, "M5-search")
    }

    func testCaptureTrash() throws {
        // Trash needs an archived note. Archive a demo note, then show Trash --
        // so the shot carries real content instead of an empty state.
        let app = launchSeeded()
        XCTAssertTrue(app.staticTexts["Vim Motions"].waitForExistence(timeout: 20))
        app.staticTexts["Vim Motions"].firstMatch.tap()
        XCTAssertTrue(app.textFields["note-title-field"].waitForExistence(timeout: 15))

        let trashButton = app.buttons["move-to-trash-button"].firstMatch
        if trashButton.waitForExistence(timeout: 5), trashButton.isHittable {
            trashButton.tap()
        } else if app.buttons["More"].firstMatch.waitForExistence(timeout: 5) {
            app.buttons["More"].firstMatch.tap()
            app.buttons["Move to Trash"].firstMatch.tap()
        }

        let toggle = app.buttons["toggle-trash-button"].firstMatch
        if toggle.waitForExistence(timeout: 5), toggle.isHittable {
            toggle.tap()
        } else if app.buttons["More"].firstMatch.waitForExistence(timeout: 5) {
            app.buttons["More"].firstMatch.tap()
            app.buttons["Show Trash"].firstMatch.tap()
        }

        XCTAssertTrue(app.staticTexts["Vim Motions"].waitForExistence(timeout: 15))
        shoot(app, "M6-trash-list")

        app.staticTexts["Vim Motions"].firstMatch.tap()
        guard app.buttons["restore-note-button"].waitForExistence(timeout: 10) else {
            XCTFail("Trash detail did not open for the marketing capture")
            return
        }
        shoot(app, "M7-trash-detail")
    }
}
