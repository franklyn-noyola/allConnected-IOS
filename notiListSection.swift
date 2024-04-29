//
//  notiListSection.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 27/8/21.
//

import UIKit

class notiListSection: UITableViewCell {
    
    @IBOutlet weak var imageURL: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var attachedLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var plateName: UILabel!
    @IBOutlet weak var readIcon: UIImageView!
    @IBOutlet weak var subjectField: UILabel!
    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var attachedField: UILabel!
    @IBOutlet weak var dateField: UILabel!
    
    func getNotiList(data : notiListInit) {
        
        fromLbl.text = data.fromLbl
        subjectLbl.text = data.subjectLbl
        messageLbl.text = data.messageLbl
        attachedLbl.text = data.attachedLbl
        plateName.text = data.plate
        dateField.text = data.date
        subjectField.text = data.subject
        messageField.text = data.message
        imageURL.text = data.imageURL
        imageURL.isHidden = true
        attachedField.text = "       " + data.attached
        
        if (data.read == "Si") {
            readIcon.image = UIImage(systemName: "envelope.open.fill")
        }else {
            readIcon.image = UIImage(systemName: "envelope.fill")
        }
        
        if (data.attached == "") {
            imageIcon.isHidden = true
            attachedField.isHidden = true
            attachedLbl.isHidden = true
            
        }else {
            imageIcon.isHidden = false
            attachedField.isHidden = false
            attachedLbl.isHidden = false
        }
    }
    
}
