//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

open class OverlayView: NSView, OverlayPart {

    open override var canBecomeKeyView: Bool { return true }
    open override var isFlipped: Bool { return true }
    open override var frame: NSRect {
        didSet {
            updateCutout()
        }
    }

    open override var isHidden: Bool {
        didSet {
            if isHidden { cutoutBreathingLoop.reset() }
            else { animateCutoutBreathing() }

            resetCursorOverride()
        }
    }

    open var overlayColor = NSColor(white: 0, alpha: 0.4)
    private(set) var appGuideStepViewModel: AppGuideStepViewModel? {
        didSet {
            self.isHidden = (appGuideStepViewModel == nil)
            self.updateCutout()
        }
    }

    open func display(appGuideStep: AppGuideStepViewModel) {

        self.appGuideStepViewModel = appGuideStep
    }

    open func hideOverlayStep() {

        self.appGuideStepViewModel = nil
    }

    private func animateCutoutBreathing() {
        guard appGuideStepViewModel != nil else { return }
        guard !cutoutBreathingLoop.isAnimating else { return }
        cutoutBreathingLoop.start()
    }

    private lazy var cutoutBreathingLoop: ValueAnimationLoop = {
        let animationLoop = ValueAnimationLoop(
            value: 4,
            increaseDuration: 1.5,
            increaseCurve: .easeIn,
            decreaseDuration: 2,
            decreaseCurve: .easeOut)
        animationLoop.progressHandler = { [weak self] in self?.cutoutPadding = $0 }
        return animationLoop
    }()

    private var cutoutPadding: CGFloat = 0 {
        didSet {
            updateCutout()
        }
    }

    private var cutoutPath: NSBezierPath?

    private func updateCutout() {

        defer { self.needsDisplay = true }

        guard let cutoutView = appGuideStepViewModel?.cutoutView else {
            cutoutPath = nil
            return
        }

        let referenceViewRect = cutoutView.superview!.convert(cutoutView.frame, to: self)
        let innerSpacing: CGFloat = 2

        self.cutoutPath = {
            let cutoutRect = NSRect(
                x: referenceViewRect.origin.x - innerSpacing - cutoutPadding,
                y: referenceViewRect.origin.y - innerSpacing - cutoutPadding,
                width: referenceViewRect.size.width + 2 * innerSpacing + 2 * cutoutPadding,
                height: referenceViewRect.size.height + 2 * innerSpacing + 2 * cutoutPadding)

            let radius = 2 * innerSpacing + cutoutPadding

            return NSBezierPath(roundedRect: cutoutRect, xRadius: radius, yRadius: radius)
        }()
    }

    open override func draw(_ dirtyRect: NSRect) {

        guard let cutoutPath = cutoutPath else { return }
        guard let context = NSGraphicsContext.current else { return }

        overlayColor.setFill()
        dirtyRect.fill()

        context.cgContext.setBlendMode(.destinationOut)
        NSColor.black.setFill() // 100% opacity for cutout
        cutoutPath.fill()

        context.cgContext.setBlendMode(.normal)
    }

    private var mouseMovedTrackingArea: NSTrackingArea?

    private func resetCursorOverride() {

        if let oldArea = mouseMovedTrackingArea {
            removeTrackingArea(oldArea)
        }

        let trackingArea = NSTrackingArea(rect: self.frame, options: [.activeInKeyWindow, .inVisibleRect, .mouseMoved], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
        mouseMovedTrackingArea = trackingArea

        // TODO: Known issue: When the overlay is triggered while the cursor is not an arrow, the cursor will not be set to be an arrow unless the mouse moves
    }

    open override func mouseMoved(with event: NSEvent) {
        NSCursor.arrow.set()
    }

    open override func mouseUp(with event: NSEvent) { }
    open override func mouseDown(with event: NSEvent) { }

    open override func keyDown(with event: NSEvent) {
        self.interpretKeyEvents([event])
    }
}
