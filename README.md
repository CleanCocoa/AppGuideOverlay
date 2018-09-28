# AppGuideOverlay

![Swift 4.2](https://img.shields.io/badge/Swift-4.2-blue.svg?style=flat)
![Version](https://img.shields.io/github/tag/CleanCocoa/AppGuideOverlay.svg?style=flat)
![License](https://img.shields.io/github/license/CleanCocoa/AppGuideOverlay.svg?style=flat)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg?style=flat)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

macOS user interface guide to display an overlay with descriptions of NSViews in your app.

## Usage

### Example

Have a look at the example app that is part of this repository. The basic setup looks like this:

```swift
// Given access to interesting view components ...
let window: NSWindow = ...
let textField: NSTextField = ...
let button: NSButton = ...

// ... and an AppGuide with steps attached to them ...
let appGuide = AppGuide(steps: [
    AppGuide.Step(title: "A Text Field",
          detail: "Use this to type something.",
          position: .below,
          cutoutView: textField),
    AppGuide.Step(title: "A Button",
          detail: "Press this to make something happen.",
          position: .right,
          cutoutView: button)
    ])

// ... keep the AppGuideOverlay around and start it:
let appGuideOverlay = AppGuideOverlay(
    appGuide: appGuide,
    appGuideSuperview: window.contentView!)
appGuideOverlay.start()
```

### Types of Interest

- `AppGuide` is the model. It contains an array of `AppGuide.Step`s that represents the steps in your guide.
- `AppGuideOverlay` is a convenient service object to set up the app guide and control it. (You don't have to use it and can use `AppGuidePresenter` and a `HandlesOverlayEvents` conforming delegate. But `AppGuideOverlay` really is the most useful façade to get started.)
- `AppGuideOverlayDelegate` is used to react to progress and completion events.

## Features

- **Uses Auto Layout** to position the `AppGuide.Step` contents next to the view the steps explain. This ensures the window size fits the labels at all times. It also ensures the step's description is displayed correctly when the window is resized. 
    <div align="center">
    <img src="img/auto-layout.gif" />
    </div>
- **Tasteful** pulsation of the cutout frame's size in the overlay. This also indicates that the app doesn't just hang.
    <div align="center">
    <img src="img/breathing.gif" />
    </div>
- **Good citizen:** No custom `NSRunLoop` or anything. It's just a view on top of other views that captures the first responder status and doesn't give it back to underlying controls. This means you can remote-control your user interface to change display content and animate as usual while the overlay is visible.

## Code License

Copyright (c) 2018 Christian Tietze. Distributed under the MIT License.

- Uses [LoopingAnimation](https://github.com/CleanCocoa/LoopingAnimation) code directly, also distributed under the MIT License.
