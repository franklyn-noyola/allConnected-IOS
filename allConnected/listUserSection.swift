//
//  listUserSection.swift
//  allConnected
//
//  Created by Franklyn Garica Noyola on 31/5/21.
//

import UIKit

class listUserSection: UITableViewCell {
    
    @IBOutlet weak var plateNameField: UILabel!
    
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var bodyField: UILabel!
    
    @IBOutlet weak var dateField: UILabel!
    
    @IBOutlet weak var imageBody: UILabel!
    func getDataUser(data : listSectionInit) {
        pictureImage.isHidden = true
        plateNameField.text = data.plate
        dateField.text = data.date
        bodyField.text = data.body
        imageBody.text = data.body
        
        if data.messageType == "image" {
            imageBody.isHidden = false
            pictureImage.isHidden = false
            bodyField.isHidden = true
        }else {
            imageBody.isHidden = true
            pictureImage.isHidden = true
            bodyField.isHidden = false
        }
        if data.blocked == "Si" {
            plateNameField.textColor = .gray
            dateField.textColor = .gray
            imageBody.textColor = .gray
            bodyField.textColor = .gray
            pictureImage.tintColor = .gray
        }else {
            plateNameField.textColor = .black
            dateField.textColor = .black
            imageBody.textColor = .black
            bodyField.textColor = .black
            pictureImage.tintColor = .blue
        }
        
        
    }
    
    
    
}
