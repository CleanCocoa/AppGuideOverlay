//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

public struct AppGuide {
    public let steps: [Step]

    public subscript (_ index: Int) -> Step {
        return steps[index]
    }

    public var count: Int { return steps.count }

    public init(steps: [Step]) {
        self.steps = steps
    }
    
    public struct Step {
        public let title: String
        public let detail: String
        public let position: Position
        public let cutoutView: NSView

        public init(
            title: String,
            detail: String,
            position: Position,
            cutoutView: NSView) {

            self.title = title
            self.detail = detail
            self.position = position
            self.cutoutView = cutoutView
        }

        public enum Position {
            case above, below, left, right
        }
    }
}
