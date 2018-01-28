//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.
//  <https://github.com/CleanCocoa/LoopingAnimation>

import AppKit

/// `NSAnimation` that reports smooth, un-marked animation progress directly through `progressHandler`.
internal class SmoothAnimation: NSAnimation {
    internal var progressHandler: ((NSAnimation.Progress) -> Void)?
    internal override var currentProgress: NSAnimation.Progress {
        didSet {
            progressHandler?(currentProgress)
        }
    }
}
