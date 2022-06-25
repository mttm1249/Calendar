//
//  Event.swift
//  Calendar
//
//  Created by Денис on 27.03.2022.
//

import Foundation
import RealmSwift

class Event: Object {
    
    @objc dynamic var eventText: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var withNotification: Bool = false
    @objc dynamic var notificationDate: String = ""

    
    convenience init(eventText: String, date: String, isDone: Bool, withNotification: Bool, notificationDate: String) {
        
        self.init()
        self.eventText = eventText
        self.date = date
        self.isDone = isDone
        self.notificationDate = notificationDate
        self.withNotification = withNotification
    }
}
