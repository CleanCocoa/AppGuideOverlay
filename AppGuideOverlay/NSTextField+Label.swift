//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

extension NSTextField {

    private func fittingSystemFont() -> NSFont {
        return NSFont.systemFont(ofSize: NSFont.systemFontSize(for: self.controlSize))
    }

    /// Return an `NSTextField` configured exactly like one created by dragging a “Label” into a storyboard.
    class func newLabel(
        title: String = "",
        controlSize: NSControl.ControlSize = .regular) -> NSTextField {

        let label = NSTextField()
        label.isEditable = false
        label.isSelectable = false
        label.textColor = .labelColor
        label.backgroundColor = .controlColor
        label.drawsBackground = false
        label.isBezeled = false
        label.alignment = .natural
        label.controlSize = controlSize
        label.font = label.fittingSystemFont()
        label.lineBreakMode = .byClipping
        label.cell?.isScrollable = true
        label.cell?.wraps = false
        label.stringValue = title
        return label
    }

    /// Return an `NSTextField` configured exactly like one created by dragging a “Wrapping Label” into a storyboard.
    class func newWrappingLabel(
        title: String = "",
        controlSize: NSControl.ControlSize = .regular) -> NSTextField {

        let label = newLabel(title: title, controlSize: controlSize)
        label.lineBreakMode = .byWordWrapping
        label.cell?.isScrollable = false
        label.cell?.wraps = true
        return label
    }
}
