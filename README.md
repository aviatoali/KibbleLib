# KibbleLib

[![CI Status](https://img.shields.io/travis/aviatoali/KibbleLib.svg?style=flat)](https://travis-ci.org/aviatoali/KibbleLib)
[![Version](https://img.shields.io/cocoapods/v/KibbleLib.svg?style=flat)](https://cocoapods.org/pods/KibbleLib)
[![License](https://img.shields.io/cocoapods/l/KibbleLib.svg?style=flat)](https://cocoapods.org/pods/KibbleLib)
[![Platform](https://img.shields.io/cocoapods/p/KibbleLib.svg?style=flat)](https://cocoapods.org/pods/KibbleLib)

Bits and pieces (get it? Kibbles and bits? :D...sorry, I'm better than this) of extensions and utils that have been gathered over time to make future apps and projects more convenient. 

## Features

### Pinview

```swift
    let pinEntryView = PinEntryView()
    pinEntryView.delegate = self
    pinEntryView.length = 6
```

![Alt text](/KibbleLib/Assets/pinview.png "PinEntryView")

![Alt text](/KibbleLib/Assets/pinview_dob.png "PinEntryView DOB Sample")

### UnderlineTextField

```swift
let textField = UnderlineTextField()
textField.fieldDelegate = self
```

![Alt text](/KibbleLib/Assets/textField.png "UnderlineTextField")

### FormActionView

```swift
let actionView = FormActionView(title: "FormActionView", buttonColor: .blue, enabledbyDefault: true)
actionView.delegate = self
```

![Alt text](/KibbleLib/Assets/standard_button.png "FormActionView")

![Alt text](/KibbleLib/Assets/buttons_joined.png "FormActionView Joined")

![Alt text](/KibbleLib/Assets/button_loading.png "FormActionView with an image")

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 12
## Installation

KibbleLib is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KibbleLib'
```

## Author

Ali H. Shah, email: aviatoali@gmail.com, [linkedin](https://www.linkedin.com/in/ali-shah-717144123/)

## License

KibbleLib is available under the MIT license. See the LICENSE file for more info.
