//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

/// Can be used as `HandlesOverlayEvents` controller out of the box to control
/// the transition and view/hide its `view`.
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

    public func finish() {
        view.hide()
        stepIndex = 0
    }

    public func cancel() {
        view.hide()
        stepIndex = 0
    }

    public func displayStep() {
        precondition(appGuide.steps.indices.contains(stepIndex))
        let viewModel = currentAppGuideStepViewModel()
        view.display(appGuideStep: viewModel)
    }

    private func currentAppGuideStepViewModel() -> AppGuideStepViewModel {

        let base = currentStep

        let isFirstStep = !hasPreviousStep
        let isLastStep = !hasNextStep

        return AppGuideStepViewModel(
            title: base.title,
            detail: base.detail,
            isFirstStep: isFirstStep,
            isLastStep: isLastStep,
            position: base.position,
            cutoutView: base.cutoutView)
    }
}
