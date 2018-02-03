//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

/// Default button labels, loaded as localized strings. Can be overridden.
public struct OverlayButtonLabels {
    /// Name of the localization table file.    
    public static let tableName = "AppGuideOverlay"

    /// `AppGuideOverlay.Previous` in `AppGuideOverlay.strings`
    static var previous = NSLocalizedString("AppGuideOverlay.Previous", tableName: OverlayButtonLabels.tableName, bundle: Bundle.main, value: "Previous", comment: "")

    /// `AppGuideOverlay.Next` in `AppGuideOverlay.strings`
    static var next = NSLocalizedString("AppGuideOverlay.Next", tableName: OverlayButtonLabels.tableName, bundle: Bundle.main, value: "Continue", comment: "")

    /// `AppGuideOverlay.Finish` in `AppGuideOverlay.strings`
    static var finish = NSLocalizedString("AppGuideOverlay.Finish", tableName: OverlayButtonLabels.tableName, bundle: Bundle.main, value: "Complete Guide", comment: "")
}
