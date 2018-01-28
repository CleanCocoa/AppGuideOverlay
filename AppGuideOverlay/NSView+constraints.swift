//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

internal extension NSView {
    func constrainToSuperviewBounds() {

        guard let superview = self.superview
            else { preconditionFailure("superview has to be set first") }

        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }

    func addConstraints(visualFormats: [String], views: [String : Any]) {

        let constraints = visualFormats
            .map { NSLayoutConstraint.constraints(withVisualFormat: $0, options: [], metrics: nil, views: views) }
            .joined()
            .asArray()
        self.addConstraints(constraints)
    }
}

internal extension Sequence {
    func asArray() -> [Element] {
        return Array(self)
    }
}
