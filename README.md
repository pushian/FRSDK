# FRSDK
FaceRecog PhotoCollage SDK for OSP

# Installation
## Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SnapKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Pushian/FRSDK"
```

Run `carthage update` to build the framework and drag the following built 
`Alamofire.framework`
`AlamofireImage.framework`
`FRPhotoCollageSDK.framework`
`SnapKit.framework`
`SVProgressHUD.framework`
`SwiftyJSON.framework`
as well as the bundle file `FRPhotoCollageSDK.bundle` inside `FRPhotoCollageSDK.framework`
into your Xcode project.


# Usage

## Quick Start

```swift
import FRSDK

class MyViewController: UIViewController {

   func functionToTriggerPhotoCollage() {
        let vc = FRPhotoCollageCreate()
        vc.delegate = self 
        
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }

}
```
## Call Back Functions

```swift
extension MyViewController: FRPhotoCollageCreateDelegate {
    func didTapCancel() {
        debugPrint("PhotoCollage is dismissed.")
    }
    
    func didTapDone() {
        debugPrint("PhotoCollage is completed.")
    }
    
}
```

