//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

public protocol DisplaysAppGuide {
    func display(appGuideStep: AppGuide.Step)
    func hide()
}

public class AppGuidePresenter: HandlesOverlayEvents {

    public let appGuide: AppGuide
    public let view: DisplaysAppGuide

    public init(appGuide: AppGuide, view: DisplaysAppGuide) {
        self.view = view
        self.appGuide = appGuide
    }

    private var stepIndex = 0
    public var hasNextStep: Bool { return stepIndex < (appGuide.count - 1) }
    public var hasPreviousStep: Bool { return stepIndex > 0 }

    public var currentStep: AppGuide.Step { return appGuide[stepIndex] }

    public func start() {
        stepIndex = 0
        displayStep()
    }


    public func nextStep() {
        guard hasNextStep else { return }
        stepIndex += 1
        displayStep()
    }

    public func previousStep() {
        guard hasPreviousStep else { return }
        stepIndex -= 1
        displayStep()
    }

    public func cancel() {
        view.hide()
        stepIndex = 0
    }

    public func displayStep() {
        precondition(appGuide.steps.indices.contains(stepIndex))
        view.display(appGuideStep: currentStep)
    }
}
