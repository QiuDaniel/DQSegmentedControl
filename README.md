# DQSegmentedControl
A drop-in replacement for UISegmentedControl mimicking the style of the segmented control

# Features
- Supports text
- Supports advanced title styling with text attributes for font, color, kerning, shadow, etc.
- Supports selection indicator both on top and bottom
- Works with ARC and iOS >= 8

## Todo
- Supports images

# Installation

### CocoaPods
The easiest way of installing DQSegmentedControl is via [CocoaPods](http://cocoapods.org/). 

```
pod 'DQSegmentedControl'
```

# Usage

The code below will create a segmented control with the default looks:

```  Swift
let control = DQSegmentedControl(frame: CGRect(x: 0, y: 34, width: UIScreen.main.bounds.width, height: 60))
control.sectionTitles = ["大前天","前天", "昨天", "今天", "明天", "后天", "大后天"]
control.delegate = self
control.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16),.foregroundColor:UIColor.black]
control.selectedTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 16),.foregroundColor:UIColor.red]
control.selectionIndicatorHeight = 2
control.selectionIndicatorColor = UIColor.red
control.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0);
view.addSubview(control)

```

Included is a demo project showing how to fully customise the control.
![Show](https://github.com/QiuDaniel/DQSegmentedControl/blob/master/snap.gif)

## Special Thanks to [@HeshamMegid](http://twitter.com/HeshamMegid), the project refer to his HMSegmentedControl much more.

# License

DQSegmentedControl is licensed under the terms of the MIT License. Please see the [LICENSE](LICENSE.md) file for full details.
