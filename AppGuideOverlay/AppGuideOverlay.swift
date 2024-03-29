//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

public protocol AppGuideOverlayDelegate: AnyObject {
    /// Use to prepare your user interface to display all necessary elements.
    func appGuideWillAppear()

    /// Called when the guide was aborted, e.g. by hitting Esc.
    func appGuideDidCancel()

    /// Called when the guide was seen through to the end.
    func appGuideDidFinish()
}

public protocol HandlesOverlayEvents: AnyObject {
    func nextStep()
    func previousStep()
    func finish()
    func cancel()
}

/// Convenience service object for simple setup of overlays.
///
/// Sets up an `AppGuidePresenter` and `AppGuideViewController`, forwarding
/// control events to its `delegate`.
///
/// Puts the app gudie overlay views into the view hierarchy on `start` and
/// removes them when finished to clear the Auto Layout constraints.
///
/// - React to events implementing `AppGuideOverlayDelegate`.
/// - Change button labels using `OverlayButtonLabels`.
open class AppGuideOverlay {

    open weak var delegate: AppGuideOverlayDelegate?

    public let appGuideViewController: AppGuideViewController

    open var appGuideView: NSView { return appGuideViewController.view }

    /// Setting for the containment view itself
    open var wantsLayer: Bool {
        get { return appGuideView.wantsLayer }
        set { appGuideView.wantsLayer = newValue }
    }

    open var overlayColor: NSColor {
        get { return appGuideViewController.overlayColor }
        set { appGuideViewController.overlayColor = newValue }
    }

    public let appGuidePresenter: AppGuidePresenter

    open var appGuide: AppGuide { return appGuidePresenter.appGuide }

    public let appGuideSuperview: NSView

    /// Indicates if invoking "next" via keyboard will automatically finish the
    /// sequence if it's at the end. Defaults to `false`.
    open var isFinishingAfterNext: Bool = false

    required public init(appGuide: AppGuide, appGuideSuperview: NSView) {

        self.appGuideViewController = AppGuideViewController()
        self.appGuidePresenter = AppGuidePresenter(
            appGuide: appGuide,
            view: appGuideViewController)
        self.appGuideSuperview = appGuideSuperview

        appGuideViewController.eventHandler = self
    }

    fileprivate func installAppGuideIntoSuperview() {

        appGuideSuperview.addSubview(self.appGuideView)
        appGuideView.constrainToSuperviewBounds()
    }

    fileprivate func removeAppGuideFromSuperview() {

        appGuideView.removeFromSuperview()
    }
}

extension AppGuideOverlay: HandlesOverlayEvents {

    public func start() {
        delegate?.appGuideWillAppear()

        installAppGuideIntoSuperview()

        appGuidePresenter.start()
    }

    public func nextStep() {
        if  isFinishingAfterNext,
            !appGuidePresenter.hasNextStep {
            finish()
            return
        }

        appGuidePresenter.nextStep()
    }

    public func previousStep() {
        appGuidePresenter.previousStep()
    }

    public func cancel() {
        stop()
        delegate?.appGuideDidCancel()
    }

    public func finish() {
        stop()
        delegate?.appGuideDidFinish()
    }

    private func stop() {
        
        appGuidePresenter.cancel()
        removeAppGuideFromSuperview()
    }
}
