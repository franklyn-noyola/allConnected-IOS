//
//  notiListInit.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 27/8/21.
//

import UIKit

class notiListInit {

    var plate : String
    var date : String
    var read : String
    var subject : String
    var message : String
    var attached : String
    var fromLbl : String
    var subjectLbl : String
    var messageLbl : String
    var attachedLbl : String
    var imageURL : String
    
    init (plate : String, date : String, read : String, subject : String, message : String, attached : String, fromLbl : String, subjectLbl : String, messageLbl : String, attachedLbl : String, imageURL : String) {
        
            self.plate = plate
            self.date = date
            self.read = read
            self.subject = subject
            self.message = message
            self.attached = attached
            self.fromLbl = fromLbl
            self.subjectLbl = subjectLbl
            self.messageLbl = messageLbl
            self.attachedLbl = attachedLbl
            self.imageURL = imageURL
    }

}
