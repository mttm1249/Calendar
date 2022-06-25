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
