//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

open class OverlayButton: DarkButton, OverlayPart {

    public enum Action {
        case previous, next, finish

        public var imageName: NSImage.Name {
            switch self {
            case .previous: return "prevTemplate.pdf"
            case .next: return "nextTemplate.pdf"
            case .finish: return "finishTemplate.pdf"
            }
        }

        public var image: NSImage? {
            return Bundle(for: OverlayButton.self).image(forResource: imageName)
        }

        public var imagePosition: NSControl.ImagePosition {
            switch self {
            case .previous: return .imageLeft
            case .next, .finish: return .imageRight
            }
        }

        public var title: String {
            switch self {
            case .previous: return OverlayButtonLabels.previous
            case .next: return OverlayButtonLabels.next
            case .finish: return OverlayButtonLabels.finish
            }
        }

        public func configure(button: OverlayButton) {
            button.title = self.title
            button.templateImage = self.image
            button.imagePosition = self.imagePosition
            button.imageScaling = .scaleProportionallyDown
            button.sizeToFit()
        }
    }

    internal func changeNextImage(isLastStep: Bool) {
        let action: Action = isLastStep ? .finish : .next
        self.templateImage = action.image
    }
}

// MARK: - Fixes for unlegible text and images in dark buttons

/// To fix the dark button appearance in light mode, the image and title colors are
/// customized. Automatic updates happen when you change any of these:
///
/// - `title`: changes the `attributedTitle` with the correct color
/// - `templateImage`: updates `image` with a tint;
/// - `image`: as a fallback, when the `image.isTemplate` is `true`, overrides `templateImage` and installs a non-tinted copy
/// - `isEnabled`: updates `image` and `title` with the expected tints
open class DarkButton: NSButton {

    override open var title: String {
        didSet {
            updateTitleColor()
        }
    }

    private func updateTitleColor() {
        var attributes = self.attributedTitle.attributes(
            at: 0,
            longestEffectiveRange: nil,
            in: NSRange(location: 0, length: self.attributedTitle.length))
        attributes[.foregroundColor] = isEnabled ? NSColor.white : NSColor.black

        self.attributedTitle = NSAttributedString(
            string: self.title,
            attributes: attributes)
    }

    open override var image: NSImage? {
        didSet {
            guard let image = self.image else { return }
            guard image.isTemplate else { return }
            self.templateImage = image
        }
    }

    var templateImage: NSImage? {
        didSet {
            updateImageFromTemplate()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            updateImageFromTemplate()
        }
    }

    private func updateImageFromTemplate() {
        guard let templateImage = self.templateImage else { return }
        self.image = templateImage.tintedNonTemplate(color: self.isEnabled ? .white : .black)
    }
}

extension NSImage {
    fileprivate func tintedNonTemplate(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()

        // To distinguish the original vector template from the tinted variant, make it not a template
        image.isTemplate = false

        return image
    }
}
