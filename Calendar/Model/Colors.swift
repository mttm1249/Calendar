//
//  Colors.swift
//  Calendar
//
//  Created by Денис on 31.03.2022.
//

import UIKit
import FSCalendar

class ColorDefaults {
            
var activeDefaultColors: Bool! {
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
        
    let colorKeys = ["color1", "color2","color3", "color4",
                     "color5", "color6","color7", "color8",
                     "color9", "color10", "color11"]
    
    let cellNames = ["Название месяца", "Названия дней недели",
                     "Дни выбранного месяца", "Дни следующего месяца",
                     "Цвет индикатора", "Сегодняшний день",
                     "Выбранный день", "Выбран сегодняшний день",
                     "Выходные дни", "Цвет выбранной даты",
                     "Цвет фона"]
    
    func customizeAppearanceFor(calendar: FSCalendar) {
        let options = OptionsViewController()
       
        let color1 = options.userDefaults.colorForKey(key: "color1")
        let color2 = options.userDefaults.colorForKey(key: "color2")
        let color3 = options.userDefaults.colorForKey(key: "color3")
        let color4 = options.userDefaults.colorForKey(key: "color4")
        let color5 = options.userDefaults.colorForKey(key: "color5")
        let color6 = options.userDefaults.colorForKey(key: "color6")
        let color7 = options.userDefaults.colorForKey(key: "color7")
        let color8 = options.userDefaults.colorForKey(key: "color8")
        let color9 = options.userDefaults.colorForKey(key: "color9")
        let color10 = options.userDefaults.colorForKey(key: "color10")

        calendar.appearance.caseOptions           = [.headerUsesUpperCase]

        calendar.appearance.weekdayFont           = .boldSystemFont(ofSize: 16)
        calendar.appearance.titleFont             = .boldSystemFont(ofSize: 15)
        calendar.appearance.calendar.firstWeekday =  2
        calendar.appearance.headerTitleColor      =  color1
        calendar.appearance.weekdayTextColor      =  color2
        calendar.appearance.titleDefaultColor     =  color3
        calendar.appearance.titlePlaceholderColor =  color4
        calendar.appearance.eventDefaultColor     =  color5
        calendar.appearance.todayColor            =  color6
        calendar.appearance.selectionColor        =  color7
        calendar.appearance.todaySelectionColor   =  color8
        calendar.appearance.titleWeekendColor     =  color9
        calendar.appearance.titleSelectionColor   =  color10
    }
}
