//
//  Options.swift
//  wefwefw
//
//  Created by Денис on 27.03.2022.
//

import Foundation
import RealmSwift

class Options: Object {
    
    @objc dynamic var imageData: Data?

    convenience init(imageData: Data?) {
        
        self.init()
        self.imageData = imageData
    }
}
