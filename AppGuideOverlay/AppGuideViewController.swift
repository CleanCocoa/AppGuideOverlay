//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

open class AppGuideViewController: NSViewController, DisplaysAppGuide {

    open weak var eventHandler: HandlesOverlayEvents? {
        get { return overlayViewController.eventHandler }
        set { overlayViewController.eventHandler = newValue }
    }

    open var overlayViewController: OverlayViewController!
    open var overlayLabelViewController: OverlayLabelViewController!

    /// Spacing between the cutout view and its overlay labels.
    open var overlayLabelSpacing: CGFloat = 12

    open override func loadView() {

        self.view = NSView()
    }

    open override func viewDidLoad() {

        let overlayViewController = OverlayViewController()
        self.view.addSubview(overlayViewController.overlayView)
        overlayViewController.overlayView.constrainToSuperviewBounds()

        let overlayLabelViewController = OverlayLabelViewController()
        overlayViewController.overlayView.addSubview(overlayLabelViewController.overlayLabelView)
        addLabelConstraints(overlayLabelView: overlayLabelViewController.overlayLabelView)

        self.overlayViewController = overlayViewController
        self.overlayLabelViewController = overlayLabelViewController
    }

    /// Ensure the constrainingView always fits the overlayLabelView.
    private func addLabelConstraints(overlayLabelView: OverlayLabelView) {

        let views: [String : Any] = ["labels" : overlayLabelView]
        let constrainingView = self.view
        constrainingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=20)-[labels]-(>=20)-|", options: [], metrics: nil, views: views))
        constrainingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=20)-[labels]-(>=20)-|", options: [], metrics: nil, views: views))
    }

    open func display(appGuideStep: AppGuide.Step) {

        overlayViewController.display(
            appGuideStep: appGuideStep)
        overlayLabelViewController.display(
            appGuideStep: appGuideStep,
            spacing: overlayLabelSpacing)

        // `layoutSubtreeIfNeeded()` didn't force the frame to change before the cutout would be drawn at the wrong coordinates, but `layout()` does.
        overlayViewController.overlayView.layout()
    }

    open func hide() {

        overlayViewController.hide()
        overlayLabelViewController.hide()
    }
}
