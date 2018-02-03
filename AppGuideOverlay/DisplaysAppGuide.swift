//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import class AppKit.NSView

public protocol DisplaysAppGuide {
    func display(appGuideStep: AppGuideStepViewModel)
    func hide()
}

public struct AppGuideStepViewModel {

    public let title: String
    public let detail: String

    public let isFirstStep: Bool
    public let isLastStep: Bool

    public let position: AppGuide.Step.Position
    public let cutoutView: NSView

    public init(
        title: String,
        detail: String,
        isFirstStep: Bool,
        isLastStep: Bool,
        position: AppGuide.Step.Position,
        cutoutView: NSView) {

        self.title = title
        self.detail = detail

        self.isFirstStep = isFirstStep
        self.isLastStep = isLastStep

        self.position = position
        self.cutoutView = cutoutView
    }
}
