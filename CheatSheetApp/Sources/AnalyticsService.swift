import Foundation
import TelemetryDeck

/// Thin wrapper around TelemetryDeck: aggregate, anonymous usage signals only
/// (e.g. "a note was pinned"), never note content or other user data.
///
/// Signals are no-ops until `appID` is replaced with a real App ID from
/// https://dashboard.telemetrydeck.com -- until then this sends nothing.
enum AnalyticsService {
    private static let appID = "REPLACE_WITH_TELEMETRYDECK_APP_ID"

    private static let isConfigured = UUID(uuidString: appID) != nil

    static func start() {
        guard isConfigured else { return }
        TelemetryDeck.initialize(config: TelemetryDeck.Config(appID: appID))
    }

    static func send(_ signal: String) {
        guard isConfigured else { return }
        TelemetryDeck.signal(signal)
    }
}
