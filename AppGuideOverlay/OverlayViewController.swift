//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

open class OverlayViewController: NSViewController {

    open weak var eventHandler: HandlesOverlayEvents?

    open var overlayView: OverlayView! {
        get { return self.view as! OverlayView }
        set { self.view = newValue }
    }

    open var overlayColor: NSColor {
        get { return overlayView.overlayColor }
        set { overlayView.overlayColor = newValue }
    }

    open override func loadView() {

        let overlayView = OverlayView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.overlayView = overlayView
    }

    private var appGuideStepIsLastInGuide = false

    open func display(appGuideStep: AppGuideStepViewModel) {

        overlayView.isHidden = false
        overlayView.display(appGuideStep: appGuideStep)
        appGuideStepIsLastInGuide = appGuideStep.isLastStep

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

    /// Responder chain callback from the "continue" button.
    @IBAction func nextStep(_ sender: Any?) {
        nextStep()
    }

    func nextStep() {
        eventHandler?.nextStep()
    }

    /// Responder chain callback from the "previous" button.
    @IBAction func previousStep(_ sender: Any?) {
        previousStep()
    }

    func previousStep() {
        eventHandler?.previousStep()
    }

    /// Responder chain callback from the "continue" button, now used as "complete".
    @IBAction func finishGuide(_ sender: Any?) {
        finish()
    }

    func finish() {
        eventHandler?.finish()
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
        continueOrFinish()
    }

    open override func insertNewlineIgnoringFieldEditor(_ sender: Any?) {
        continueOrFinish()
    }

    private func continueOrFinish() {
        if appGuideStepIsLastInGuide {
            finish()
        } else {
            nextStep()
        }
    }
}
