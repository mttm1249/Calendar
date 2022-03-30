//
//  Event.swift
//  wefwefw
//
//  Created by Денис on 27.03.2022.
//


import Foundation
import RealmSwift

class Event: Object {
    
    @objc dynamic var eventText: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var isDone: Bool = false
    
    convenience init(eventText: String, date: String, isDone: Bool) {
        
        self.init()
        self.eventText = eventText
        self.date = date
        self.isDone = isDone
    }
}
