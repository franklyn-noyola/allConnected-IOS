//
//  viewNotification.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 29/8/21.
//

import UIKit
import Firebase

class viewNotification: UIViewController {
    

    var userLanguageSelected : String!
    var del_notification : String!
    var fromScreen : String!
    var yesButtonLbl : String!
    var noButtonLbl : String!
    var delete_notification : String!
    var gotChat : String!
    var back : String!
    var delete : String!
    var reply : String!
    var from : String!
    var plateName : String!
    var deletedNotification : String!
    var subject : String!
    var message : String!
    var attached : String!
    var date : String!
    var deleted : Bool = false
    var plateNumber : String!
    var attachedData : String!
    var messageData : String!
    var dateData : String!
    var subjectData : String!
    var imageURL : String!
    var userRef : DatabaseReference!
    @IBOutlet weak var attachedLbl: UILabel!
    @IBOutlet weak var dateField: UILabel!
    
    @IBOutlet weak var imageIcon: UIButton!
    @IBOutlet weak var attachedB: UIButton!
    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var attachedField: UILabel!
    @IBOutlet weak var subjectField: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var fromLbl: UILabel!
    
    @IBOutlet weak var plateField: UILabel!
    
    
    @IBOutlet weak var square: UILabel!
    @IBOutlet weak var goChatLbl: UIButton!
    
    @IBOutlet weak var deleteLbl: UIButton!
    
    @IBOutlet weak var replyLbl: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        userRef = Database.database().reference()
        changeLanguage()
        goChatLbl.setTitle(gotChat, for: UIControl.State.normal)
        deleteLbl.setTitle(delete, for: UIControl.State.normal)
        replyLbl.setTitle(reply, for: UIControl.State.normal)
        fromLbl.text = from
        subjectLbl.text = subject
        attachedLbl.text = attached
        messageLbl.text = message
        dateLbl.text = date
        plateField.text = plateNumber
        messageField.text = messageData
        dateField.text = dateData
        subjectField.text = subjectData
        attachedField.text = attachedData.removeWithSpace()
        messageField.sizeToFit()
        attachedField.isHidden = true
        square.layer.cornerRadius = 8
        square.layer.borderWidth = 2

        
        
        if (attachedField.text!.isEmpty) {
            attachedLbl.isHidden = true
            attachedB.isHidden = true
            imageIcon.isHidden = true
        }else {
            attachedLbl.isHidden = false
            attachedB.isHidden = false
            attachedB.setTitle(attachedField.text!, for: UIControl.State.normal)
            imageIcon.isHidden = false
        }
    }
    
    @IBAction func goChat(_ sender: Any) {
        goToChat()
    }
    
    
    @IBAction func replyNotification(_ sender: Any) {
        goToNotification()
    }
    
    
    @IBAction func replyImage(_ sender: Any) {
        goToNotification()
    }
    
    @IBAction func deleteNotification(_ sender: Any) {
        delNotification()
    }
    
    @IBAction func goChatImage(_ sender: Any) {
        goToChat()
    }
    
    func goToNotification() {
        let goSendNotification = storyboard?.instantiateViewController(identifier: "sendNotification") as! sendNotification
        
        goSendNotification.userLanguageSelected = self.userLanguageSelected.uppercased()
        goSendNotification.plateName = plateName
        goSendNotification.userTarget = plateNumber
        goSendNotification.subjectNotification = "RE: " + subjectData
        goSendNotification.fromScreen = "2"
        
        self.navigationController?.pushViewController(goSendNotification, animated: true)
    }
    
    @IBAction func delNotiImage(_ sender: Any) {
        delNotification()
    }
    
    @IBAction func imageIconAction(_ sender: Any) {
        getImageView()
    }
    
    @IBAction func attachedBAction(_ sender: Any) {
        getImageView()
    }
    
    func goToChat() {
        let goChat = storyboard?.instantiateViewController(identifier: "chatView") as! chatViewSection
               
        self.navigationController?.pushViewController(goChat, animated: true)
        goChat.userLanguageSelected=userLanguageSelected
        goChat.userToChat = plateNumber
        goChat.plateNumber = plateName
        goChat.screenFrom = "2"
        
        goChat.imageURLV = imageURL
        goChat.dateData = dateData
        goChat.subjectData = subjectData
        goChat.messageData = messageData
        goChat.attachedData = attachedData
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        let backItem = UIBarButtonItem()
        backItem.title = back
        navigationItem.backBarButtonItem = backItem
        self.tabBarController?.tabBar.isHidden = true
        title = plateNumber + "-" + subjectData
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        
         let goViewNotification = storyboard?.instantiateViewController(identifier: "notificationSB") as! notificationController
         if (fromScreen == "1") {
             goViewNotification.plateName = plateName
             goViewNotification.userLanguageSelected = userLanguageSelected
             self.navigationController?.pushViewController(goViewNotification, animated: false)
         }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        if (deleted == false) {
         self.tabBarController?.tabBar.isHidden = false
        let updateRead = userRef.child("sendMessages").child(plateName)
        let updateQuery = updateRead.queryOrdered(byChild: "messageTime").queryEqual(toValue: dateData)
        updateQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                var key : String = ""
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    key = snap.key
                }
                print (key)
                self.userRef.child("sendMessages").child(self.plateName).child(key).updateChildValues(["leido": "Si"])
            }else {
             return
            }
        })
    }
        
    }
    
    
    
    func getImageView() {
        let getURL = NSURL(string: imageURL)! as URL
        var getImage = UIImage()
        if let imageData : NSData = NSData(contentsOf: getURL) {
            getImage = UIImage(data : imageData as Data)!
        }
        let newImageView =  UIImageView (image: getImage)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissImageScreen))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissImageScreen(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func delNotification() {
        let alert = UIAlertController(title: self.del_notification, message: self.delete_notification, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: self.yesButtonLbl, style: UIAlertAction.Style.default) {_ in
            let notiListData = self.userRef.child("sendMessages").child(self.plateName)
            let listQuery = notiListData.queryOrdered(byChild: "messageTime").queryEqual(toValue: self.dateData)
            listQuery.observeSingleEvent(of: .value, with: {(snapshot) in
                var key : String = ""
                if (snapshot.exists()){
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        key = snap.key
                    }
                    notiListData.child(key).removeValue()
                }
            })
            self.showToast(message: self.deletedNotification, font: .systemFont(ofSize: 12.0))
            let goViewNotification = self.storyboard?.instantiateViewController(identifier: "notificationSB") as! notificationController
            goViewNotification.plateName = self.plateName
            goViewNotification.userLanguageSelected = self.userLanguageSelected
                self.navigationController?.pushViewController(goViewNotification, animated: false)
            self.deleted = true
            
        })
        alert.addAction(UIAlertAction(title: self.noButtonLbl, style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true)
        self.deleted = false
        }
    
    func changeLanguage(){
        var languages = languageTranslation().englishLanguage
              
        if (userLanguageSelected == "ES"){
            languages = languageTranslation().spanishLanguage
        
        }
        if (userLanguageSelected == "EN"){
            languages = languageTranslation().englishLanguage
        }
        
        if (userLanguageSelected == "FR"){
            languages = languageTranslation().frenchLanguage
        }
        
        if (userLanguageSelected == "DE"){
            languages = languageTranslation().germanLanguage
        }
        
        if (userLanguageSelected == "IT"){
            languages = languageTranslation().italianLanguage
        }
        
        if (userLanguageSelected == "PT"){
            languages = languageTranslation().portugueseLanguage
        }
        
        if (userLanguageSelected == "RU"){
            languages = languageTranslation().russianLanguage
        }
        
        if (userLanguageSelected == "ZH"){
            languages = languageTranslation().chineseLanguage
        }
        
        if (userLanguageSelected == "JA"){
            languages = languageTranslation().japaneseLanguage
        }
        
        if (userLanguageSelected == "NL"){
            languages = languageTranslation().dutchLanguage
        }
        
        if (userLanguageSelected == "PL"){
            languages = languageTranslation().polishLanguage
        }
        if (userLanguageSelected == "KO"){
            languages = languageTranslation().koreanLanguage
        }
        
        if (userLanguageSelected == "SV"){
            languages = languageTranslation().swedishLanguage
        }
        if (userLanguageSelected == "AR"){
            languages = languageTranslation().arabicLanguage
        }
        if (userLanguageSelected == "UR"){
            languages = languageTranslation().urduLanguage
        }
        if (userLanguageSelected == "HI"){
            languages = languageTranslation().hindiLanguage
        }
        
        del_notification = languages["del_notification"]!
        delete_notification = languages["delete_notification"]!
        gotChat = languages["gotChat"]!
        delete = languages["delete"]!
        reply = languages["reply"]!
        from = languages["from"]!
        subject = languages["subject"]!
        message = languages["message"]!
        attached = languages["attached"]!
        deletedNotification = languages["deletedNotification"]!
        date = languages["date"]!
        noButtonLbl = languages["No"]!
        yesButtonLbl = languages["yes"]!
        back = languages["back"]!
        
    }
    

}

extension String {
    func removeWithSpace() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
