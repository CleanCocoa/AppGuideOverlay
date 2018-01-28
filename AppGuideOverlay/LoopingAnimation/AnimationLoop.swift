//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.
//  <https://github.com/CleanCocoa/LoopingAnimation>

import AppKit

internal class AnimationLoop: NSObject, NSAnimationDelegate {

    internal let configuration: LoopConfiguration

    private var runningAnimation: DirectedAnimation!
    internal var currentOperation: Operation { return runningAnimation.operation }
    internal var isAnimating: Bool { return runningAnimation.isAnimating }

    /// Value betweem 0.0 and 1.0
    internal typealias Progress = CGFloat
    internal var progressHandler: ((Progress, Operation) -> Void)?

    /// Sets up an animation loop.
    ///
    /// - parameter configuration: Configuration of the looping animation parts.
    /// - parameter initialOperation: Which animation loop operation to start with. Defaults to `.increment`.
    internal required init(
        configuration: LoopConfiguration,
        startWith initialOperation: Operation = .increment) {

        self.configuration = configuration

        super.init()

        self.runningAnimation = createAnimation(operation: initialOperation)
    }

    /// Sets up a loop with a `LoopConfiguration` of the parameters from this initializer.
    ///
    /// - parameter increaseDuration: Time the increase animations will take.
    /// - parameter increaseCurve: Animation curve of increase animations.
    /// - parameter decreaseDuration: Time the decreaste animations will take.
    /// - parameter decreaseCurve: Animation curve of decrease animations.
    /// - parameter initialOperation: Which animation loop operation to start with. Defaults to `.increment`.
    internal convenience init(
        increaseDuration: TimeInterval,
        increaseCurve: NSAnimation.Curve,
        decreaseDuration: TimeInterval,
        decreaseCurve: NSAnimation.Curve,
        startWith initialOperation: Operation = .increment) {

        self.init(
            configuration: LoopConfiguration(
                increase: .init(duration: increaseDuration, animationCurve: increaseCurve),
                decrease: .init(duration: decreaseDuration, animationCurve: decreaseCurve)),
            startWith: initialOperation)
    }

    /// Sets up a loop of 2 animations with increase and decrease both
    /// configured the same way.
    ///
    /// - parameter duration: Duration of both the increase and decrease animation.
    /// - parameter animationCurve: Animation curve of both the increase and decrease animation.
    internal convenience init(duration: TimeInterval, animationCurve: NSAnimation.Curve) {
        self.init(increaseDuration: duration, increaseCurve: animationCurve,
                  decreaseDuration: duration, decreaseCurve: animationCurve)
    }

    /// Sets up a loop of 2 animations with a default duration of 1 second
    /// and `.easeInOut` animation curve.
    internal convenience override init() {
        self.init(duration: 1, animationCurve: .easeInOut)
    }

    private func createAnimation(operation: Operation) -> DirectedAnimation {

        let animation = configuration.step(operation: operation).smoothAnimation()
        animation.animationBlockingMode = .nonblocking
        animation.delegate = self
        animation.progressHandler = { [weak self] in self?.animationDidProgress($0) }
        return DirectedAnimation(
            animation: animation,
            operation: operation)
    }

    private func animationDidProgress(_ progress: NSAnimation.Progress) {
        progressHandler?(CGFloat(progress), currentOperation)
    }

    internal func animationDidEnd(_ animation: NSAnimation) {
        guard animation === self.runningAnimation.animation else { return }
        startNextAnimation()
    }

    private func startNextAnimation() {
        let nextOperation = !self.currentOperation
        let nextAnimation = createAnimation(operation: nextOperation)
        self.runningAnimation = nextAnimation
        nextAnimation.start()
    }

    internal func start() {

        guard !isAnimating else { preconditionFailure("Cannot start while running") }

        runningAnimation.start()
    }

    internal func reset() {

        self.runningAnimation.cancel()
        self.runningAnimation = createAnimation(operation: .increment)
    }

    internal struct DirectedAnimation {

        internal let animation: SmoothAnimation
        internal var isAnimating: Bool { return animation.isAnimating }

        internal let operation: Operation

        internal init(animation: SmoothAnimation, operation: Operation) {
            self.animation = animation
            self.operation = operation
        }

        internal func start() {
            animation.start()
        }

        internal func cancel() {
            // Do not forward the last frame event that `stop()` will emit.
            animation.progressHandler = { _ in }
            animation.stop()
        }
    }

    internal enum Operation {
        case increment
        case decrement

        internal static prefix func !(_ operation: Operation) -> Operation {
            if operation ~= .increment { return .decrement }
            return .increment
        }
    }

    internal struct LoopConfiguration {
        internal let increase: AnimationStep
        internal let decrease: AnimationStep

        internal init(increase: AnimationStep, decrease: AnimationStep) {
            self.increase = increase
            self.decrease = decrease
        }

        internal func step(operation: Operation) -> AnimationStep {
            switch operation {
            case .increment: return increase
            case .decrement: return decrease
            }
        }

        internal struct AnimationStep {
            internal let duration: TimeInterval
            internal let animationCurve: NSAnimation.Curve

            internal init(duration: TimeInterval, animationCurve: NSAnimation.Curve) {
                self.duration = duration
                self.animationCurve = animationCurve
            }

            internal func smoothAnimation() -> SmoothAnimation {
                return SmoothAnimation(duration: duration, animationCurve: animationCurve)
            }
        }
    }
}
