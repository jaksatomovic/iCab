import Foundation
import UIKit

open class Settings {
  open class func registerDefaults() {
    let userDefaults = UserDefaults.groupUserDefaults()

    // The defaults registered with registerDefaults are ignore by the Today Extension. :/
    if (!userDefaults.bool(forKey: "DEFAULTS_INSTALLED")) {
        userDefaults.set(true, forKey: "DEFAULTS_INSTALLED")
        userDefaults.set("", forKey: Constants.General.name.key())
        userDefaults.set("", forKey: Constants.General.registration.key())
        userDefaults.set(0, forKey: Constants.General.age.key())
        let image = #imageLiteral(resourceName: "help-circle")
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        userDefaults.set(imageData, forKey: Constants.General.avatar.key())
    }
    userDefaults.synchronize()
  }
}
