# KibbleLib

[![Version](https://img.shields.io/cocoapods/v/KibbleLib.svg?style=flat)](https://cocoapods.org/pods/KibbleLib)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
[![Platform](https://img.shields.io/cocoapods/p/KibbleLib.svg?style=flat)](https://cocoapods.org/pods/KibbleLib)

Bits and pieces (get it? Kibbles and bits? :D...sorry, I'm better than this) of extensions and utils that have been gathered over time to make future apps and projects more convenient. 

## Features

### Pinview

```swift
let pinEntryView = PinEntryView()
pinEntryView.delegate = self
pinEntryView.length = 6
```

![Alt text](https://github.com/aviatoali/KibbleLib/blob/master/KibbleLib/Assets/pinview.png?raw=true "PinEntryView")

![Alt text](https://github.com/aviatoali/KibbleLib/blob/master/KibbleLib/Assets/pinview_dob.png?raw=true "PinEntryView DOB Sample")

### UnderlineTextField

```swift
let textField = UnderlineTextField()
textField.fieldDelegate = self
```

![Alt text](https://github.com/aviatoali/KibbleLib/blob/master/KibbleLib/Assets/textField.png?raw=true "UnderlineTextField")

### FormActionView

```swift
let actionView = FormActionView(title: "FormActionView", buttonColor: .blue, enabledbyDefault: true)
actionView.delegate = self
```

![Alt text](https://github.com/aviatoali/KibbleLib/blob/master/KibbleLib/Assets/standard_button.png?raw=true "FormActionView")

![Alt text](https://github.com/aviatoali/KibbleLib/blob/master/KibbleLib/Assets/buttons_joined.png?raw=true "FormActionView Joined")

![Alt text](https://github.com/aviatoali/KibbleLib/blob/master/KibbleLib/Assets/button_loading.png?raw=true "FormActionView with an image")

### Convenience extension methods

#### UIView shake animation
```swift
let view = UIView()
view.Shake()
```
#### Add array of subviews & remove all subviews
```swift
view.AddSubviews(view1, view2, view3)
view.RemoveAllSubviews()
```

#### UIView Shake Animation
```swift
let view = UIView()
view.Shake()
```

### Add gesture recognizers through handler closure, or by passing handler
```swift
view.AddSingleTapRecoWith(action: self.shakeView)
view.AddTapRecoWith(numberOfTaps: 2, action: self.shakeView)
view.AddLongPressRecoWith { [weak self] longPress -> Void in
    if let sSelf = self {
        sSelf.view.Shake()
    }
}
```

### String extension for LocalizedString syntax simplification
```swift
"sample_localized_string".Localized()
```

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
