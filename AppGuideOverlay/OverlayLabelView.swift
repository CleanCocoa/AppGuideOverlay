//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

open class OverlayLabelView: NSView {

    open let titleLabel: NSTextField
    open let detailLabel: NSTextField

    open let previousStepButton: NSButton
    open let nextStepButton: NSButton

    public override init(frame frameRect: NSRect) {

        self.titleLabel = OverlayLabelView.newTitleLabel()
        self.detailLabel = OverlayLabelView.newDetailLabel()
        self.previousStepButton = OverlayLabelView.newButton(title: OverlayButtonLabels.previous)
        self.nextStepButton = OverlayLabelView.newButton(title: OverlayButtonLabels.next)

        super.init(frame: frameRect)

        layoutLabels()
    }

    public required init?(coder decoder: NSCoder) {

        self.titleLabel = OverlayLabelView.newTitleLabel()
        self.detailLabel = OverlayLabelView.newDetailLabel()
        self.previousStepButton = OverlayLabelView.newButton(title: OverlayButtonLabels.previous)
        self.nextStepButton = OverlayLabelView.newButton(title: OverlayButtonLabels.next)

        super.init(coder: decoder)

        layoutLabels()
    }

    private static func newTitleLabel() -> NSTextField {

        let titleLabel = NSTextField.newLabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = NSFont.systemFont(ofSize: 24, weight: .light)
        titleLabel.textColor = .white
        titleLabel.identifier = .init(rawValue: "OverlayTitleLabel")
        return titleLabel
    }

    private static func newDetailLabel() -> NSTextField {

        let detailLabel = NSTextField.newWrappingLabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = NSFont.systemFont(ofSize: 14, weight: .regular)
        detailLabel.textColor = .white
        detailLabel.identifier = .init(rawValue: "OverlayDetailLabel")
        return detailLabel
    }

    private static func newButton(title: String) -> NSButton {

        let button = NSButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bezelStyle = .recessed
        button.title = title
        return button
    }

    open var target: Any?
    open var previousAction: Selector?
    open var nextAction: Selector?
    open var finishAction: Selector?

    private func layoutLabels() {

        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(previousStepButton)
        addSubview(nextStepButton)

        self.addConstraints(
            visualFormats: [
                "H:|[title]|",
                "H:|[detail]|",
                "H:|[prev]-(12)-[next]",

                "V:|[title]-(8)-[detail]-(12)-[prev]|"
            ],
            views: [
                "title" : titleLabel,
                "detail" : detailLabel,
                "prev" : previousStepButton,
                "next" : nextStepButton
            ])
        self.addConstraints([NSLayoutConstraint(item: nextStepButton, attribute: .firstBaseline, relatedBy: .equal, toItem: previousStepButton, attribute: .firstBaseline, multiplier: 1, constant: 0)])
    }

    open func changeText(title: String, detail: String) {

        titleLabel.stringValue = title
        titleLabel.sizeToFit()

        detailLabel.stringValue = detail
        detailLabel.sizeToFit()

        layoutSubtreeIfNeeded()
    }

    open func changeButtons(isFirstStep: Bool, isLastStep: Bool) {

        previousStepButton.isEnabled = !isFirstStep
        previousStepButton.target = nil
        previousStepButton.action = previousAction

        nextStepButton.title = isLastStep
            ? OverlayButtonLabels.finish
            : OverlayButtonLabels.next
        nextStepButton.target = nil
        nextStepButton.action = isLastStep
            ? self.finishAction
            : self.nextAction
    }
}
