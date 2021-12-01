//
//  contactView.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 2/9/21.
//

import UIKit
import Firebase

class contactView: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var sendButton: UIButton!
    var languages = languageTranslation().hindiLanguage
    var selectIssueOptions = languageTranslation().selectNotiIssuesHI
    var userLanguageSelected : String!
    var action_contacts : String!
    var subject : String!
    var selected : Bool = false
    var selectedItem : String!
    var sentMessage : String = ""
    var userRef : DatabaseReference!
    var replayContactMessage : String!
    var message : String!
    var selectIssue : String!
    var emptyMessage : String!
    var send : String!
    var screen : String = ""
    var targetMessageContacto : String!
    var support : String!
    var issueEmpty : String!
    
    
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var messageField: UITextView!
    
    @IBOutlet weak var subjectButton: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var subjectList: UITableView!
    @IBOutlet weak var supportTeam: UILabel!
    var plateName : String = ""
    
    @IBOutlet weak var imageButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectList.isHidden = true
        userRef = Database.database().reference()
        enableFields()
        changeLanguage()
        self.hideKeyboardWhenTappedAround()
        self.title = action_contacts
        sendButton.setTitle(send, for: UIControl.State.normal)
        subjectButton.setTitle(selectIssue, for: UIControl.State.normal)
        subjectLbl.text = subject
        messageLbl.text = message
        subjectButton.layer.cornerRadius = 8
        subjectButton.layer.borderWidth = 1
        messageField.layer.cornerRadius = 8
        messageField.layer.borderWidth = 1
        messageField.textColor = UIColor.lightGray
        messageField.text = targetMessageContacto
        messageField.delegate = self
        supportTeam.text = support
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.isNavigationBarHidden = false
    }
    
    func enableFields() {
        messageField.isEditable = true
        subjectButton.isEnabled = true
        sendButton.isEnabled = true
        imageButton.isEnabled = true
    }
    
    func disableFields() {
        messageField.isEditable = false
        subjectButton.isEnabled = false
        sendButton.isEnabled = false
        imageButton.isEnabled = false
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = targetMessageContacto
        }
    }
    
    func textViewDidBeginEditing(_ textView : UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func subjectAction(_ sender: Any) {
        if (subjectList.isHidden == true){
            subjectList.isHidden = false
            
        }else{
            subjectList.isHidden = true
        }
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        sendContactMessage()
    }
    
 
    
    @IBAction func imageAction(_ sender: Any) {
        sendContactMessage()
    }
    
    func sendContactMessage() {
        if (subjectButton.title(for: UIControl.State.normal) == selectIssue) {
            self.showToast(message: self.issueEmpty, font: .systemFont(ofSize: 14.0))
            return
            
        }
        if (messageField.textColor == UIColor.lightGray) {
            self.showToast(message: self.emptyMessage, font: .systemFont(ofSize: 14.0))
            return
        }
        let sendEmail = sendEmail()
        let getEmail = userRef.child("Users")
        let getEmailQuery = getEmail.queryOrdered(byChild: "plate_user").queryEqual(toValue: plateName)
        
        var supportTeam : String = ""
        
        if (userLanguageSelected == "ES") {
            supportTeam = "Soporte allConnected"
        }else {
            supportTeam = "allConnected Support"
        }
        
        getEmailQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            var getEmailAddress : String = ""
            if (snapshot.exists()) {
                for child in snapshot.children {
                    let dataChild = child as! DataSnapshot
                    let data = dataChild.value as! [String : Any]
                    getEmailAddress = data["user_email"] as? String ?? ""
                }
                sendEmail.sendEmail(usertoSend: "allConnected", recipient: "allconnected@epicdevelopers.es", subject: self.subjectButton.title(for: UIControl.State.normal)!, message: "Usuario: " + self.plateName +  "<br>" + "Asunto: " + self.subjectButton.title(for: UIControl.State.normal)!+"<br>"+"Mensaje: " + self.messageField.text, fromName: self.plateName)
            }
            
            sendEmail.sendEmail(usertoSend: "allConnected", recipient: "allconnected@epicdevelopers.es", subject: self.subjectButton.title(for: UIControl.State.normal)!, message: "Usuario: " + self.plateName +  "<br>" + "Asunto: " + self.subjectButton.title(for: UIControl.State.normal)!+"<br>"+"Mensaje: " + self.messageField.text, fromName: self.plateName)
            
            sendEmail.sendEmail(usertoSend: self.plateName, recipient: getEmailAddress, subject: self.subjectButton.title(for: UIControl.State.normal)!, message: self.replayContactMessage, fromName: supportTeam)
            self.showToast(message: self.sentMessage, font: .systemFont(ofSize: 14.0))
            self.changeScreen()
           
        })
    }
    
    func changeScreen() {
        if (screen == "0") {
            let goHome = storyboard?.instantiateViewController(identifier: "homeSB") as! profileViewControler
            goHome.userLanguageSelected = self.userLanguageSelected.uppercased()
            goHome.plateName = plateName
            self.navigationController?.pushViewController(goHome, animated: true)
            return
        }
        if (screen == "1") {
            let goProfile = storyboard?.instantiateViewController(identifier: "ProfileViewSB") as! profileSection
            goProfile.userLanguageSelected = self.userLanguageSelected.uppercased()
            goProfile.plateName = plateName
            self.navigationController?.pushViewController(goProfile, animated: true)
        }
        if (screen == "2") {
            let goChat = storyboard?.instantiateViewController(identifier: "chatSB") as! chatController
            goChat.userLanguageSelected = self.userLanguageSelected.uppercased()
            goChat.plateName = plateName
            self.navigationController?.pushViewController(goChat, animated: true)
        }
        if (screen == "3") {
            let goNotification = storyboard?.instantiateViewController(identifier: "notificationSB") as! notificationController
            goNotification.userLanguageSelected = self.userLanguageSelected.uppercased()
            goNotification.plateName = plateName
            self.navigationController?.pushViewController(goNotification, animated: true)
        }
    }
    
    func changeLanguage()  {
        
        if (userLanguageSelected == "ES"){
            languages = languageTranslation().spanishLanguage
            selectIssueOptions = languageTranslation().selectContactIssueES
        }
        if (userLanguageSelected == "EN"){
            languages = languageTranslation().englishLanguage
            selectIssueOptions = languageTranslation().selectContactIssueEN
        }
  
        if (userLanguageSelected == "FR"){
            languages = languageTranslation().frenchLanguage
            selectIssueOptions = languageTranslation().selectContactIssueFR
        }
  
        if (userLanguageSelected == "DE"){
            languages = languageTranslation().germanLanguage
            selectIssueOptions = languageTranslation().selectContactIssueDE
        }
  
        if (userLanguageSelected == "IT"){
            languages = languageTranslation().italianLanguage
            selectIssueOptions = languageTranslation().selectContactIssueIT
        }
  
        if (userLanguageSelected == "PT"){
            languages = languageTranslation().portugueseLanguage
            selectIssueOptions = languageTranslation().selectContactIssuePT
        }
  
        if (userLanguageSelected == "RU"){
            languages = languageTranslation().russianLanguage
            selectIssueOptions = languageTranslation().selectContactIssueRU
        }
  
        if (userLanguageSelected == "ZH"){
            languages = languageTranslation().chineseLanguage
            selectIssueOptions = languageTranslation().selectContactIssueZH
        }
  
        if (userLanguageSelected == "JA"){
            languages = languageTranslation().japaneseLanguage
            selectIssueOptions = languageTranslation().selectContactIssueJA
        }
  
        if (userLanguageSelected == "NL"){
            languages = languageTranslation().dutchLanguage
            selectIssueOptions = languageTranslation().selectContactIssueNL
        }
  
        if (userLanguageSelected == "PL"){
            languages = languageTranslation().polishLanguage
            selectIssueOptions = languageTranslation().selectContactIssuePL
        }
        if (userLanguageSelected == "KO"){
            languages = languageTranslation().koreanLanguage
            selectIssueOptions = languageTranslation().selectContactIssueKO
        }
  
        if (userLanguageSelected == "SV"){
            languages = languageTranslation().swedishLanguage
            selectIssueOptions = languageTranslation().selectContactIssueSV
        }
        if (userLanguageSelected == "AR"){
            languages = languageTranslation().arabicLanguage
            selectIssueOptions = languageTranslation().selectContactIssueAR
        }
        if (userLanguageSelected == "UR"){
            languages = languageTranslation().urduLanguage
            selectIssueOptions = languageTranslation().selectContactIssueUR
        }
        if (userLanguageSelected == "HI"){
            languages = languageTranslation().hindiLanguage
            selectIssueOptions = languageTranslation().selectContactIssueHI
        }
        
        action_contacts = languages["action_contacts"]!
        action_contacts = languages["action_contacts"]!
        subject = languages["subject"]!
        message = languages["message"]!
        selectIssue = languages["selectIssue"]!
        send = languages["sendText"]!
        targetMessageContacto = languages["targetMessageContacto"]!
        support = languages["support"]!
        issueEmpty = languages["issueEmpty"]!
        emptyMessage = languages["emptyMessage"]!
        replayContactMessage = languages["replayContactMessage"]!
        sentMessage = languages["sentMessage"]!

    }

  
}

extension contactView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectIssueOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = UITableViewCell (style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
            cel.textLabel?.text = selectIssueOptions[indexPath.row]
            return cel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                    IndexPath){
        
        self.selectedItem = selectIssueOptions[indexPath.row]
        self.selected = true
        subjectList?.isHidden=true
        self.subjectButton.setTitle(selectedItem, for: UIControl.State.normal)
    }
    
    
}
