//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

public protocol DisplaysAppGuide {
    func display(appGuideStep: AppGuide.Step)
    func hide()
}

public protocol HandlesOverlayEvents: class {
    func nextStep()
    func previousStep()
    func cancel()
}

public class AppGuidePresenter: HandlesOverlayEvents {

    public let appGuide: AppGuide
    public let view: DisplaysAppGuide

    public init(appGuide: AppGuide, view: DisplaysAppGuide) {
        self.view = view
        self.appGuide = appGuide
    }

    private var stepIndex = 0

    public func start() {
        stepIndex = 0
        displayStep()
    }

    public func nextStep() {
        guard stepIndex < (appGuide.steps.count - 1) else { return }
        stepIndex += 1
        displayStep()
    }

    public func previousStep() {
        guard stepIndex > 0 else { return }
        stepIndex -= 1
        displayStep()
    }

    public func cancel() {
        view.hide()
    }

    public func displayStep() {
        precondition(appGuide.steps.indices.contains(stepIndex))
        let step = appGuide.steps[stepIndex]
        view.display(appGuideStep: step)
    }
}
