# SimpleAlert

[![Carthage Compatibility](https://img.shields.io/badge/carthage-✓-f2a77e.svg?style=flat)](https://github.com/Carthage/Carthage/)
[![Version](https://img.shields.io/cocoapods/v/SimpleAlert.svg?style=flat)](http://cocoadocs.org/docsets/SimpleAlert)
[![License](https://img.shields.io/cocoapods/l/SimpleAlert.svg?style=flat)](http://cocoadocs.org/docsets/SimpleAlert)
[![Platform](https://img.shields.io/cocoapods/p/SimpleAlert.svg?style=flat)](http://cocoadocs.org/docsets/SimpleAlert)

It is simple and easily customizable alert.  
Can be used as `UIAlertController`, it supports from iOS7.

<p><img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/default_view.png" alt="default_view" width="150" />
<img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/custom_view.png" alt="custom_view" width="150" />
<img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/custom_content.png" alt="custom_content" width="150" />
<img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/rounded_view.png" alt="rounded_view" width="150" /></p>


## Add to your project (iOS8.0 or later)

### 1. Add project
Add `SimpleAlert.xcodeproj` to your target.
<p><img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/add_file.png" alt="add_file" width="400" /></p>

### 2. Add Embedded Binaries `SimpleAlert.framework`
<p><img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/add_embedded.png" alt="add_embedded" width="400" /></p>

Select `SimpleAlert.framework` in the `Workspace`.
<p><img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/choose_framework.png" alt="choose_framework" width="200" /></p>

### 3. Add `Configuration` (Option)
If you are adding a `Configuration` to the target, please manually add the ` Configuration` in the same way also to SimpleAlert.
<p><img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/configurations.png" alt="configurations" width="400" /></p>

## Add to your project (iOS7.1 and earlier)

### 1. Add source

Add `SimpleAlert.swift` and `SimpleAlert.xib`.
<p><img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/add_source.png" alt="add_source" width="400" /></p>

## How to Install SimpleAlert

### Using Beta CocoaPods

You need to install the beta build of CocoaPods via `[sudo] gem install cocoapods --pre` then add SimpleAlert to your Podfile.

```Ruby
pod "SimpleAlert"
```

### Using Carthage

Add SimpleAlert to your Cartfile.

```Ruby
github "KyoheiG3/SimpleAlert"
```

## Usage

* Add `SimpleAlert` namespace for iOS7

### import

If target is ios8.0 or later, please import the `SimpleAlert`.

```Swift
import SimpleAlert
```
### Example

View simple Alert

```Swift
let alert = SimpleAlert.Controller(title: "title", message: "message", style: .Alert)

alert.addTextFieldWithConfigurationHandler()
alert.addAction(SimpleAlert.Action(title: "Cancel", style: .Cancel))
alert.addAction(SimpleAlert.Action(title: "OK", style: .OK))

presentViewController(alert, animated: true, completion: nil)
```

Customize default contents

```Swift
let alert = SimpleAlert.Controller(title: "title", message: "message", style: .Alert)
alert.addTextFieldWithConfigurationHandler() { textField in
    textField.frame.size.height = 33
    textField.backgroundColor = nil
    textField.layer.borderColor = nil
    textField.layer.borderWidth = 0
}
alert.configContentView = { [weak self] view in
    if let view = view as? SimpleAlert.ContentView {
        view.titleLabel.textColor = UIColor.lightGrayColor()
        view.titleLabel.font = UIFont.boldSystemFontOfSize(30)
        view.messageLabel.textColor = UIColor.lightGrayColor()
        view.messageLabel.font = UIFont.boldSystemFontOfSize(16)
        view.textBackgroundView.layer.cornerRadius = 3.0
        view.textBackgroundView.clipsToBounds = true
    }
}

alert.addAction(SimpleAlert.Action(title: "Cancel", style: .Cancel))
alert.addAction(SimpleAlert.Action(title: "OK", style: .OK))
presentViewController(alert, animated: true, completion: nil)

```

Rounded button Alert View

```Swift
let alert = SimpleAlert.Controller(view: UIView(), style: .Alert)
let action = SimpleAlert.Action(title: "?", style: .Cancel)

alert.addAction(action)
action.button.frame.size.height = 144
action.button.titleLabel?.font = UIFont.boldSystemFontOfSize(96)
action.button.setTitleColor(UIColor.redColor(), forState: .Normal)

alert.configContainerWidth = {
    return 144
}
alert.configContainerCornerRadius = {
    return 72
}
alert.configContentView = { view in
    view.backgroundColor = UIColor.whiteColor()
}

presentViewController(alert, animated: true, completion: nil)
```

More customizable if you create a subclass

```Swift
class AlertController: SimpleAlert.Controller {
    override func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)? = nil) {
        super.addTextFieldWithConfigurationHandler() { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = nil
            textField.layer.borderColor = nil
            textField.layer.borderWidth = 0
            
            configurationHandler?(textField)
        }
    }
    
    override func configurButton(style :SimpleAlert.Action.Style, forButton button: UIButton) {
        super.configurButton(style, forButton: button)
        
        if let font = button.titleLabel?.font {
            switch style {
            case .OK:
                button.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
                button.setTitleColor(UIColor.grayColor(), forState: .Normal)
            case .Cancel:
                button.backgroundColor = UIColor.darkGrayColor()
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            case .Default:
                button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configContentView = { [weak self] view in
            if let view = view as? SimpleAlert.ContentView {
                view.titleLabel.textColor = UIColor.lightGrayColor()
                view.titleLabel.font = UIFont.boldSystemFontOfSize(30)
                view.messageLabel.textColor = UIColor.lightGrayColor()
                view.messageLabel.font = UIFont.boldSystemFontOfSize(16)
                view.textBackgroundView.layer.cornerRadius = 3.0
                view.textBackgroundView.clipsToBounds = true
            }
        }
    }
}
```

## Class

### Action

#### Style

* Default
* OK
* Cancel
* Destructive

#### Initialize

```Swift
init(title: String, style: SimpleAlert.Action.Style, handler: ((SimpleAlert.Action!) -> Void)?)
```
* Set title and style, can add button.
* Set button action handler.

#### Variable

```Swift
var enabled: Bool
```
* Set button enabled.

```Swift
var button: UIButton!
```
* Can get a button.
* Can get after button has been added to the `Controller`.

### ContentView

`backgroundColor` of `ContentView` will be reflected in the overall `backgroundColor`.

```Swift
var baseView: UIView!
```
* Base view for contents

```Swift
var titleLabel: UILabel!
```
* Title label

```Swift
var messageLabel: UILabel!
```
* Message Label

```Swift
var textBackgroundView: UIView!
```
* Base view for Text Field
* `Controller.Style` is in the case of `ActionSheet` does not appear.

### Controller

#### Style

* Alert
* ActionSheet


#### Initialize

```Swift
init(title:String?, message:String?, style: SimpleAlert.Controller.Style)
```

* Show default view.

```Swift
init(view: UIView?, style: Controller.Style)
```

* Show custom view.
* Automatically set the width.

#### Function

```Swift
func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)?)
````
* Add Text Field, and set handler.
* `Controller.Style` is in the case of `ActionSheet` does not add.

```Swift
func addAction(action: SimpleAlert.Action)
```
* Add action button.

#### Handler

```Swift
var configContainerWidth: (() -> CGFloat?)?
```
* Change view width.

```Swift
var configContainerCornerRadius: (() -> CGFloat?)?
```
* Change view corner radius.

```Swift
var configContentView: ((UIView!) -> Void)?
```
* Customize contents.
* By default, `UIView` argument is `ContentView`.

## The difference between default `UIAlertController`

* Can add a cancel button any number of the `ActionSheet`.
* If tap the outside of the view, the action handler will not be executed of the `ActionSheet`.

## LICENSE

Under the MIT license. See LICENSE file for details.
