//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

/// Marker of views which can become `firstResponder` in `OverlainWindow`.
public protocol OverlayPart { }

/// Prevents anything that is not an `OverlayPart` to become first responder.
/// This is used to ensure that the user cannot focus views below the overlay.
open class OverlainWindow: NSWindow {

    open var isDisplayingOverlay = false

    @discardableResult
    open override func makeFirstResponder(_ responder: NSResponder?) -> Bool {
        if isDisplayingOverlay {
            guard responder is OverlayPart else { return false }
        }
        return super.makeFirstResponder(responder)
    }
}

