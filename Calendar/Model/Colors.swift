//
//  Colors.swift
//  Calendar
//
//  Created by Денис on 31.03.2022.
//

import UIKit

final class ColorDefaults {
        
   static var active: Bool! {
        get {
            UserDefaults.standard.bool(forKey: "active")
        } set {
            let defaults = UserDefaults.standard
            let key = "active"
            if let active = newValue {
                defaults.set(active, forKey: key)
            } else {
                defaults
                    .removeObject(forKey: key)
            }
        }
    }
}

extension UserDefaults {
  func colorForKey(key: String) -> UIColor? {
    var colorReturnded: UIColor?
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Error UserDefaults")
      }
    }
    return colorReturnded
  }
  
  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    set(colorData, forKey: key)
  }
}

