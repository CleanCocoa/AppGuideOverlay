//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa
import AppGuideOverlay

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: OverlainWindow!

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var comboBox: NSComboBox!
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var button1: NSButton!
    @IBOutlet weak var button2: NSButton!

    var appGuideOverlay: AppGuideOverlay!

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let appGuide = AppGuide(steps: [
            .init(title: "Omnia Sol Temperat",
                  detail: "You can use this text field to configure everything \nto your heart's content. Just do it.  Write, and go on. \nIt's simple. Very easy. You will like it.",
                  position: .below,
                  cutoutView: textField),
            .init(title: "Pressible",
                  detail: "It is a button that can be \npressed for great effect.\n\nTry to resize the window\nwhile this is active!",
                  position: .left,
                  cutoutView: button1),
            .init(title: "Purus et Subtilis",
                  detail: "Picking something from a limited list shouldn't be too hard.",
                  position: .right,
                  cutoutView: comboBox),
            .init(title: "Agenda",
                  detail: "Dates and times are what drives people mad. It is grueling\nto endure this madness of space-time. Faciem aprilis. \nAd amorem properat, animus herilis.",
                  position: .right,
                  cutoutView: datePicker),
            .init(title: "Impressible",
                  detail: "More buttons mean more fun, am I right?",
                  position: .below,
                  cutoutView: button2)
            ])

        self.appGuideOverlay = AppGuideOverlay(
            appGuide: appGuide,
            appGuideSuperview: window.contentView!)
        appGuideOverlay.isFinishingAfterNext = false
        appGuideOverlay.delegate = self
        appGuideOverlay.start()
    }

    @IBAction func showOverlay(_ sender: Any?) {
        appGuideOverlay.start()
    }
}

extension AppDelegate: AppGuideOverlayDelegate {

    func appGuideWillAppear() {

    }

    func appGuideDidFinish() {

    }

    func appGuideDidCancel() {

    }
}
