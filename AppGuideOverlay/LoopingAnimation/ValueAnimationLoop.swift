//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.
//  <https://github.com/CleanCocoa/LoopingAnimation>

import AppKit

/// Animation loop that translates animation progress to `value`.
///
/// It animates incrementing from 0...`value` and back again from `value`...0.
internal class ValueAnimationLoop {

    internal let loop: AnimationLoop
    internal let value: CGFloat

    internal var progressHandler: ((CGFloat) -> Void)?

    internal init(value: CGFloat, loop: AnimationLoop) {
        self.value = value
        self.loop = loop
    }

    /// - parameter value: The maximum value to loop to, and from which to loop back again to 0.
    /// - parameter increaseDuration: Time the increase animations will take.
    /// - parameter increaseCurve: Animation curve of increase animations.
    /// - parameter decreaseDuration: Time the decreaste animations will take.
    /// - parameter decreaseCurve: Animation curve of decrease animations.
    /// - parameter initialOperation: Which animation loop operation to start with. Defaults to `.increment`.
    internal convenience init(
        value: CGFloat,
        increaseDuration: TimeInterval = 1.0,
        increaseCurve: NSAnimation.Curve = .easeInOut,
        decreaseDuration: TimeInterval = 1.0,
        decreaseCurve: NSAnimation.Curve = .easeInOut,
        startWith initialOperation: AnimationLoop.Operation = .increment) {

        self.init(
            value: value,
            loop: AnimationLoop(
                increaseDuration: increaseDuration,
                increaseCurve: increaseCurve,
                decreaseDuration: decreaseDuration,
                decreaseCurve: decreaseCurve,
                startWith: initialOperation))

        self.loop.progressHandler = { [weak self] in self?.loopDidProgress(progress: $0, operation: $1) }
    }

    private func loopDidProgress(progress: AnimationLoop.Progress, operation: AnimationLoop.Operation) {

        guard let progressHandler = progressHandler else { return }

        let progressedValue: CGFloat = {
            switch operation {
            case .increment: return progress * value
            case .decrement: return value - (progress * value)
            }
        }()

        progressHandler(progressedValue)
    }

    internal var isAnimating: Bool { return loop.isAnimating }

    internal func start() {
        loop.start()
    }

    internal func reset() {
        loop.reset()
    }
}
