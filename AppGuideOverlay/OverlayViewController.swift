//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

open class OverlayViewController: NSViewController {

    open weak var eventHandler: HandlesOverlayEvents?

    open var overlayView: OverlayView! {
        get { return self.view as! OverlayView }
        set { self.view = newValue }
    }

    open override func loadView() {

        let overlayView = OverlayView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.overlayView = overlayView
    }

    open func display(appGuideStep: AppGuide.Step) {

        overlayView.isHidden = false
        overlayView.display(appGuideStep: appGuideStep)

        guard let overlainWindow = overlayView.window as? OverlainWindow else { return }
        overlainWindow.isDisplayingOverlay = true
        overlainWindow.makeFirstResponder(overlayView)
    }

    open func hide() {

        overlayView.isHidden = true
        overlayView.hideOverlayStep()

        guard let overlainWindow = overlayView.window as? OverlainWindow else { return }
        overlainWindow.isDisplayingOverlay = false
        overlainWindow.makeFirstResponder(overlainWindow.initialFirstResponder)
    }

    // MARK: Events

    func nextStep() {
        eventHandler?.nextStep()
    }

    func previousStep() {
        eventHandler?.previousStep()
    }

    func cancel() {
        eventHandler?.cancel()
    }

    // MARK: - NSResponder Actions

    open override func moveRight(_ sender: Any?) {
        nextStep()
    }

    open override func moveLeft(_ sender: Any?) {
        previousStep()
    }

    open override func cancelOperation(_ sender: Any?) {
        cancel()
    }

    open override func insertNewline(_ sender: Any?) {
        nextStep()
    }

    open override func insertNewlineIgnoringFieldEditor(_ sender: Any?) {
        nextStep()
    }
}
