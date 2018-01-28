//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

open class OverlayLabelViewController: NSViewController {

    open var overlayLabelView: OverlayLabelView {
        get { return self.view as! OverlayLabelView }
        set { self.view = newValue }
    }

    private var constrainingView: NSView? { return self.view.window?.contentView }

    private var activeConstraints: [NSLayoutConstraint] = []

    open override func loadView() {

        let overlayLabelView = OverlayLabelView()
        overlayLabelView.translatesAutoresizingMaskIntoConstraints = false
        self.view = overlayLabelView
    }

    open private(set) var overlayStep: AppGuide.Step?

    open func display(appGuideStep: AppGuide.Step, spacing: CGFloat) {

        self.overlayLabelView.isHidden = false
        self.overlayStep = appGuideStep

        // Update texts first to calculate the view size properly
        updateLabels(title: appGuideStep.title,
                     detail: appGuideStep.detail)
        replaceActiveConstraints(referenceView: appGuideStep.cutoutView,
                                 position: appGuideStep.position,
                                 spacing: spacing)
    }

    private func updateLabels(title: String, detail: String) {

        overlayLabelView.changeText(title: title, detail: detail)
    }

    private func replaceActiveConstraints(
        referenceView: NSView,
        position: AppGuide.Step.Position,
        spacing: CGFloat) {

        guard let constrainingView = constrainingView else { preconditionFailure("View needs to be embedded in a window's view hierarchy before displaying a value.") }

        let newConstraints: [NSLayoutConstraint] = {
            switch position {
            case .below: return [
                NSLayoutConstraint(item: overlayLabelView, attribute: .leading, relatedBy: .equal, toItem: referenceView, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: overlayLabelView, attribute: .top, relatedBy: .equal, toItem: referenceView, attribute: .bottom, multiplier: 1, constant: spacing)
                ]

            case .above: return [
                NSLayoutConstraint(item: overlayLabelView, attribute: .leading, relatedBy: .equal, toItem: referenceView, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: referenceView, attribute: .top, relatedBy: .equal, toItem: overlayLabelView, attribute: .bottom, multiplier: 1, constant: spacing)
                ]

            case .left: return [
                NSLayoutConstraint(item: referenceView, attribute: .leading, relatedBy: .equal, toItem: overlayLabelView, attribute: .trailing, multiplier: 1, constant: spacing),
                NSLayoutConstraint(item: overlayLabelView, attribute: .top, relatedBy: .equal, toItem: referenceView, attribute: .top, multiplier: 1, constant: 0)
                ]

            case .right: return [
                NSLayoutConstraint(item: overlayLabelView, attribute: .leading, relatedBy: .equal, toItem: referenceView, attribute: .trailing, multiplier: 1, constant: spacing),
                NSLayoutConstraint(item: overlayLabelView, attribute: .top, relatedBy: .equal, toItem: referenceView, attribute: .top, multiplier: 1, constant: 0)
                ]
            }
        }()

        constrainingView.removeConstraints(activeConstraints)
        constrainingView.addConstraints(newConstraints)
        self.activeConstraints = newConstraints
    }

    open func hide() {
        self.overlayLabelView.isHidden = true
    }
}
