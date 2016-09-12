# SimpleAlert

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/SimpleAlert.svg?style=flat)](http://cocoadocs.org/docsets/SimpleAlert)
[![License](https://img.shields.io/cocoapods/l/SimpleAlert.svg?style=flat)](http://cocoadocs.org/docsets/SimpleAlert)
[![Platform](https://img.shields.io/cocoapods/p/SimpleAlert.svg?style=flat)](http://cocoadocs.org/docsets/SimpleAlert)

It is simple and easily customizable alert.  
Can be used as `UIAlertController`, it supports from iOS7.

#### [Appetize's Demo](https://appetize.io/app/w12zxu30gtr8p5a7v9t37gmzp4)

<p><img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/default_view.png" alt="default_view" width="150" />
<img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/custom_view.png" alt="custom_view" width="150" />
<img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/custom_content.png" alt="custom_content" width="150" />
<img src="https://github.com/KyoheiG3/assets/blob/master/SimpleAlert/rounded_view.png" alt="rounded_view" width="150" /></p>

## Requirements

- Swift 3.0
- iOS 7.0 or later

## How to Install SimpleAlert

### iOS 8+

#### Cocoapods

Add the following to your `Podfile`:

```Ruby
pod "SimpleAlert"
use_frameworks!
```
Note: the `use_frameworks!` is required for pods made in Swift.

#### Carthage

Add the following to your `Cartfile`:

```Ruby
github "KyoheiG3/SimpleAlert"
```
### iOS 7

Just add everything in the source file to your project.

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
let alert = AlertController(title: "title", message: "message", style: .Alert)

alert.addTextFieldWithConfigurationHandler()
alert.addAction(AlertAction(title: "Cancel", style: .Cancel))
alert.addAction(AlertAction(title: "OK", style: .OK))

presentViewController(alert, animated: true, completion: nil)
```

Customize default contents

```Swift
let alert = AlertController(title: "title", message: "message", style: .Alert)
alert.addTextFieldWithConfigurationHandler() { textField in
    textField.frame.size.height = 33
    textField.backgroundColor = nil
    textField.layer.borderColor = nil
    textField.layer.borderWidth = 0
}
alert.configContentView = { [weak self] view in
    if let view = view as? AlertContentView {
        view.titleLabel.textColor = UIColor.lightGrayColor()
        view.titleLabel.font = UIFont.boldSystemFontOfSize(30)
        view.messageLabel.textColor = UIColor.lightGrayColor()
        view.messageLabel.font = UIFont.boldSystemFontOfSize(16)
        view.textBackgroundView.layer.cornerRadius = 3.0
        view.textBackgroundView.clipsToBounds = true
    }
}

alert.addAction(AlertAction(title: "Cancel", style: .Cancel))
alert.addAction(AlertAction(title: "OK", style: .OK))
presentViewController(alert, animated: true, completion: nil)

```

Rounded button Alert View

```Swift
let alert = AlertController(view: UIView(), style: .Alert)
let action = AlertAction(title: "?", style: .Cancel)

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
class AlertController: AlertController {
    override func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)? = nil) {
        super.addTextFieldWithConfigurationHandler() { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = nil
            textField.layer.borderColor = nil
            textField.layer.borderWidth = 0

            configurationHandler?(textField)
        }
    }

    override func configurButton(style :AlertAction.Style, forButton button: UIButton) {
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
            if let view = view as? AlertContentView {
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
init(title: String, style: AlertAction.Style, handler: ((AlertAction!) -> Void)?)
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
init(title:String?, message:String?, style: AlertController.Style)
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
func addAction(action: AlertAction)
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
