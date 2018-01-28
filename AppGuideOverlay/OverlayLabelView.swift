//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

open class OverlayLabelView: NSView {

    open let titleLabel: NSTextField
    open let detailLabel: NSTextField

    public override init(frame frameRect: NSRect) {

        self.titleLabel = OverlayLabelView.newTitleLabel()
        self.detailLabel = OverlayLabelView.newDetailLabel()

        super.init(frame: frameRect)

        layoutLabels()
    }

    public required init?(coder decoder: NSCoder) {

        self.titleLabel = OverlayLabelView.newTitleLabel()
        self.detailLabel = OverlayLabelView.newDetailLabel()

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

    private func layoutLabels() {

        addSubview(titleLabel)
        addSubview(detailLabel)

        self.addConstraints(
            visualFormats: [
                "H:|[title]|",
                "H:|[detail]|",
                "V:|[title][detail]|"
            ],
            views: [
                "title" : titleLabel,
                "detail" : detailLabel
            ])
    }

    open func changeText(title: String, detail: String) {

        titleLabel.stringValue = title
        titleLabel.sizeToFit()

        detailLabel.stringValue = detail
        detailLabel.sizeToFit()

        layoutSubtreeIfNeeded()
    }
}
