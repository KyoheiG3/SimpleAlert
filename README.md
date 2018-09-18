# SimpleAlert

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/SimpleAlert.svg?style=flat)](http://cocoadocs.org/docsets/SimpleAlert)
[![License](https://img.shields.io/cocoapods/l/SimpleAlert.svg?style=flat)](http://cocoadocs.org/docsets/SimpleAlert)
[![Platform](https://img.shields.io/cocoapods/p/SimpleAlert.svg?style=flat)](http://cocoadocs.org/docsets/SimpleAlert)

It is simple and easily customizable alert.
Can be used as `UIAlertController`.

#### [Appetize's Demo](https://appetize.io/app/w12zxu30gtr8p5a7v9t37gmzp4)

<p><img src="https://user-images.githubusercontent.com/5707132/33262364-56970b8c-d3a9-11e7-8f2d-54b8865bf396.png" alt="default_view" width="150" />
<img src="https://user-images.githubusercontent.com/5707132/33262361-56423fd0-d3a9-11e7-8e81-a022b33e02a9.png" alt="custom_view" width="150" />
<img src="https://user-images.githubusercontent.com/5707132/33262360-56206446-d3a9-11e7-9d30-f998f5d1b041.png" alt="custom_content" width="150" />
<img src="https://user-images.githubusercontent.com/5707132/33262365-56b85bb6-d3a9-11e7-9a6b-aa933cd2a7e2.png" alt="rounded_view" width="150" /></p>

## Requirements

- Swift 4.2
- iOS 8.0 or later

## How to Install SimpleAlert

#### Cocoapods

Add the following to your `Podfile`:

```Ruby
pod "SimpleAlert"
```

#### Carthage

Add the following to your `Cartfile`:

```Ruby
github "KyoheiG3/SimpleAlert"
```

## Usage

### Example

View simple Alert

```Swift
let alert = AlertController(title: "title", message: "message", style: .alert)

alert.addTextField()
alert.addAction(AlertAction(title: "Cancel", style: .cancel))
alert.addAction(AlertAction(title: "OK", style: .ok))

present(alert, animated: true, completion: nil)
```

Customize default contents

```Swift
let alert = AlertController(title: "title", message: "message", style: .alert)
alert.addTextField { textField in
    textField.frame.size.height = 33
    textField.backgroundColor = nil
    textField.layer.borderColor = nil
    textField.layer.borderWidth = 0
}
alert.configureContentView { view in
    view.titleLabel.textColor = UIColor.lightGrayColor()
    view.titleLabel.font = UIFont.boldSystemFontOfSize(30)
    view.messageLabel.textColor = UIColor.lightGrayColor()
    view.messageLabel.font = UIFont.boldSystemFontOfSize(16)
    view.textBackgroundView.layer.cornerRadius = 3.0
    view.textBackgroundView.clipsToBounds = true
}

alert.addAction(AlertAction(title: "Cancel", style: .cancel))
alert.addAction(AlertAction(title: "OK", style: .ok))
present(alert, animated: true, completion: nil)

```

Rounded button Alert View

```Swift
let alert = AlertController(view: UIView(), style: .alert)
alert.contentWidth = 144
alert.contentCornerRadius = 72
alert.contentColor = .white
let action = AlertAction(title: "?", style: .cancel) { action in
}

alert.addAction(action)
action.button.frame.size.height = 144
action.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 96)
action.button.setTitleColor(UIColor.red, for: .normal)

present(alert, animated: true, completion: nil)
```

More customizable if you create a subclass

```Swift
class CustomAlertController: AlertController {
    override func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        super.addTextField { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = nil
            textField.layer.borderColor = nil
            textField.layer.borderWidth = 0

            configurationHandler?(textField)
        }
    }

    override func configureActionButton(_ button: UIButton, at style :AlertAction.Style) {
        super.configureActionButton(button, at: style)

        switch style {
        case .ok:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitleColor(UIColor.gray, for: UIControlState())
        case .cancel:
            button.backgroundColor = UIColor.darkGray
            button.setTitleColor(UIColor.white, for: UIControlState())
        case .default:
            button.setTitleColor(UIColor.lightGray, for: UIControlState())
        default:
            break
        }
    }

    override func configureContentView(_ contentView: AlertContentView) {
        super.configureContentView(contentView)

        contentView.titleLabel.textColor = UIColor.lightGray
        contentView.titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        contentView.messageLabel.textColor = UIColor.lightGray
        contentView.messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.textBackgroundView.layer.cornerRadius = 10.0
        contentView.textBackgroundView.clipsToBounds = true
    }
}
```

## Class

### AlertAction

#### Style

- default
- ok
- cancel
- destructive

#### Initialize

```Swift
init(title: String, style: SimpleAlert.AlertAction.Style, dismissesAlert: Bool = default, handler: ((SimpleAlert.AlertAction?) -> Swift.Void)? = default)
```
- Set title and style, can add button.
- Set button action handler.

#### Variable

```Swift
var isEnabled: Bool
```
- Set button enabled.

```Swift
let button: UIButton
```
- Can get a button.
- Can get after button has been added to the `AlertController`.

### AlertContentView

`backgroundColor` of `AlertContentView` will be reflected in the overall `backgroundColor`.

```Swift
var baseView: UIView!
```
- Base view for contents

```Swift
var titleLabel: UILabel!
```
- Title label

```Swift
var messageLabel: UILabel!
```
- Message Label

```Swift
var textBackgroundView: UIView!
```
- Base view for Text Field
- `UIAlertControllerStyle` is in the case of `actionSheet` does not appear.

### AlertController

#### Initialize

```Swift
init(title: String?, message: String?, style: UIAlertControllerStyle)
```
- Set title, message and style, can add button.
- Set button action handler.

```Swift
init(title: String? = default, message: String? = default, view: UIView?, style: UIAlertControllerStyle)
```
- Can also set custom view.

#### Variable

```Swift
open var contentWidth: CGFloat
open var contentColor: UIColor?
open var contentCornerRadius: CGFloat?
open var coverColor: UIColor
open var message: String?
```
- Can change alert style.

```Swift
public private(set) var actions: [SimpleAlert.AlertAction]
public var textFields: [UITextField] { get }
```
- Can get actions and text fields that is added.

#### Function

```Swift
func addTextField(configurationHandler: ((UITextField) -> Swift.Void)? = default)
```

- Add Text Field, and set handler.
- `UIAlertControllerStyle` is in the case of `actionSheet` does not add.

```Swift
func addAction(_ action: SimpleAlert.AlertAction)
```
- Add action button.

```Swift
func configureActionButton(_ button: UIButton, at style: SimpleAlert.AlertAction.Style)
```
- Override if would like to configure action button.

```Swift
func configureContentView(_ contentView: SimpleAlert.AlertContentView)
```
- Override if would like to configure content view.

## The difference between default `UIAlertController`

- Can add a cancel button any number of the `actionSheet`.
- If tap the outside of the view, the action handler will not be executed of the `actionSheet`.

## Author

#### Kyohei Ito

- [GitHub](https://github.com/kyoheig3)
- [Twitter](https://twitter.com/kyoheig3)

Follow me 🎉

## LICENSE

Under the MIT license. See LICENSE file for details.
