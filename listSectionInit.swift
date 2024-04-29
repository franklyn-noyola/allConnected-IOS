//
//  listSectionInit.swift
//  allConnected
//
//  Created by Franklyn Garica Noyola on 31/5/21.
//

import Foundation
import UIKit

class listSectionInit {
    
    var plate : String
    var date : String
    var body : String
    var messageType : String
    var blocked : String
    
    init(plate : String, date : String, body : String, messageType : String, blocked : String) {
        self.plate = plate
        self.date = date
        self.body = body
        self.messageType = messageType
        self.blocked = blocked
    }
}
