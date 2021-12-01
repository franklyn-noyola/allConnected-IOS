//
//  plateNumber.swift
//  allConnected2
//
//  Created by Franklyn Garcia Noyola on 10/4/21.
//
import UIKit

class plateNumber:UITextView{
    @IBInspectable open var leftImage: UIImage?{
        didSet {
            if (leftImage != nil){
                self.applyLeftImage(leftImage!)
            }
        }
    }
    
    fileprivate func applyLeftImage(_ image: UIImage){
        let icn : UIImage = image
        let imageView = UIImageView(image: icn)
        imageView.frame = CGRect(x:0,y:2.0, width:  icn.size.width + 20, height: icn.size.height)
        imageView.contentMode = UIView.ContentMode.center
    self.addSubview(imageView)
    self.textContainerInset = UIEdgeInsets(top: 2.0, left: icn.size.width + 10.0, bottom: 2.0, right: 2.0 )
}
}
