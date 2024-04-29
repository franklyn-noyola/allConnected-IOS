//
//  howWorksTableViewCell.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 17/8/21.
//

import UIKit

class howWorksTableViewCell: UITableViewCell {

    @IBOutlet weak var Header : UILabel!
    @IBOutlet weak var Body : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Body.numberOfLines=0
        Body.sizeToFit()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
