//
//  sendNotification.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 31/8/21.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseStorage

class sendNotification: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var fromScreen : String!
    var imageURL : String!
    var subjectNotification : String!
    var userLanguageSelected : String!
    var plateName : String!
    var messageSent : String!
    var autoSend : String!
    var getImage : UIImage!
    var issueEmpty : String!
    var userTarget : String!
    var NoMessageSendLockUser : String!
    var emptyTargetUser : String!
    var userToSend : String!
    var getSubjectData : String!
    var selectedItem : String!
    var unregistered_user : String!
    var userRef : DatabaseReference!
    private let storage = Storage.storage().reference()
    var selected : Bool = false
     @IBOutlet weak var selectSubjectButtom: UIButton!
    @IBOutlet weak var targetUserLbl: UILabel!
    var languages = languageTranslation().englishLanguage
    var selectIssueOptions = [String]()
    var sendNotifications : String!
    var selectIssue : String!
    var targetUser : String!
    var targetMessage : String!
    var subject : String!
    var attached : String!
    var message : String!
    var send : String!
    
    @IBOutlet weak var attachedIcon: UIButton!
    
    @IBOutlet weak var sendImage: UIButton!
    @IBOutlet weak var sendLbl: UIButton!
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var targetUserField: UITextField!
    
    @IBOutlet weak var selectSubjectLbl: UIButton!
    @IBOutlet weak var attachedField: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!
    
    @IBOutlet weak var attachedLbl: UILabel!
    
    @IBOutlet weak var subjectList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage()
        self.title = sendNotifications
        self.hideKeyboardWhenTappedAround()
        setFieldsEnabled()
        userRef = Database.database().reference()
        sendLbl.setTitle(send, for: UIControl.State.normal)
        messageLbl.text = message
        subjectLbl.text = subject
        attachedLbl.text = attached
        selectSubjectLbl.setTitle(selectIssue, for: UIControl.State.normal)
        subjectList.isHidden = true
        attachedField.text = ""
        targetUserLbl.text = targetUser + ":"
        messageField.layer.cornerRadius = 8
        messageField.layer.borderWidth = 2
        targetUserField.layer.cornerRadius = 8
        targetUserField.layer.borderWidth = 1
        selectSubjectLbl.layer.cornerRadius = 8
        selectSubjectLbl.layer.borderWidth = 1
        messageField.text = targetMessage
        messageField.textColor = UIColor.lightGray
        messageField.delegate = self
        subjectList.delegate = self
        subjectList.dataSource = self
        selected = false
        
        if fromScreen == "0" {
            targetUserField.text = userTarget
            targetUserField.isEnabled = false
        }
        
        if fromScreen == "2" {
            targetUserField.text = userTarget
            targetUserField.isEnabled = false
            selectSubjectButtom.setTitle(subjectNotification, for: UIControl.State.normal)
            selectSubjectButtom.isEnabled = false
        }
        
    }
    
    func textViewDidBeginEditing(_ textView : UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = targetMessage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker : UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            setImage(image)
        }else {
            return
        }
          picker.dismiss(animated: true, completion: nil)
            let currentDate = Date()
            let formatDate = DateFormatter()
            formatDate.locale = NSLocale.current
            formatDate.dateFormat = "dd-MM-yyyy HH:mm"
            let dateFormat = formatDate.string(from: currentDate)
            attachedField.text = "IMAGE_" + dateFormat
        
    }
    
    func setImage (_ image : UIImage!) {
        getImage = image
      }
    

    @IBAction func selectSubjectAction(_ sender: Any) {
        if (subjectList.isHidden == true){
            subjectList.isHidden = false
            
        }else{
            subjectList.isHidden = true
        }
    }
    
    @IBAction func selectAttached(_ sender: Any) {
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        pickerVC.sourceType = .photoLibrary
        pickerVC.modalPresentationStyle = .fullScreen
        pickerVC.allowsEditing = true
        present(pickerVC, animated: true, completion: nil)
    }
    
    
    @IBAction func sendButtonAction(_ sender: Any) {
        sendAction()
    }
    
    @IBAction func snedImageAction(_ sender: Any) {
        sendAction()
    }
    
    func sendAction() {
        if (targetUserField.text!.isEmpty) {
            self.showToast(message: self.emptyTargetUser, font: .systemFont(ofSize: 14.0))
            return
        }
        if (selectSubjectButtom.title(for: UIControl.State.normal) == selectIssue) {
            self.showToast(message: self.issueEmpty, font: .systemFont(ofSize: 14.0))
            return
            
        }
        if (messageField.textColor == UIColor.lightGray) {
            self.showToast(message: self.targetMessage, font: .systemFont(ofSize: 14.0))
            return
        }
        if (plateName == targetUserField.text!.uppercased()) {
            self.showToast(message: self.autoSend, font: .systemFont(ofSize: 14.0))
            return
        }
        if selectSubjectButtom.isEnabled == false {
            getSubjectData = selectSubjectButtom.title(for: UIControl.State.disabled)
        }else{
            getSubjectData = selectSubjectButtom.title(for: UIControl.State.normal)
        }
        let getUser = userRef.child("Users")
        let getUserQuery = getUser.queryOrdered(byChild: "plate_user").queryEqual(toValue: targetUserField.text!.uppercased())
        getUserQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()) {
                self.getBlockUser(self.targetUserField.text!.uppercased())
            }else {
                self.showToast(message: self.unregistered_user, font: .systemFont(ofSize: 14.0))
                return
            }
        })
    }
    
    func getBlockUser(_ plate : String) {
        let blockedUser = userRef.child("BlockUsers").child(plateName).child(plate)
        let blockedUserQuery = blockedUser.queryOrdered(byChild: "Blocked").queryEqual(toValue: "Si")
        blockedUserQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()) {
                self.showToast(message: self.NoMessageSendLockUser, font: .systemFont(ofSize: 14.0))
                return
             }else {
                self.getUserBlokced(self.targetUserField.text!.uppercased())
            }
        })
    }
    
    func getUserBlokced(_ plate : String) {
        let blockedUser = userRef.child("BlockUsers").child(plate).child(plateName)
        let blockedUserQuery = blockedUser.queryOrdered(byChild: "Blocked").queryEqual(toValue: "Si")
        blockedUserQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()) {
                
                self.showToast(message: self.messageSent, font: .systemFont(ofSize: 14.0))
                self.setFieldsDisabled()
                return
            }else {
                self.saveData(self.targetUserField.text!.uppercased())
            }
        })
    }

    func saveData(_ plate: String) {
        
        
        if (attachedField.text! != "") {
            do {
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                let uploadData = getImage.jpegData(compressionQuality: 0.5)
                let imageReference = Storage.storage().reference().child("Imagenes/"+attachedField.text!)
                imageReference.putData(uploadData!, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print ("Upload error: \(error.localizedDescription)")
                        return
                    }
                    imageReference.downloadURL(completion: { [self] (url, error) in
                        if let error = error {
                            print("Error on getting download url: \(error.localizedDescription)")
                            return
                        }
                        let imgURL = url!.absoluteString
                        self.setData(imgURL)
                    })
                }
            }
        }else{
            imageURL = ""
            setData(imageURL)
        }
    }
    
    func setData (_ imageURL : String) {
        let sendMessageUser = userRef.child("sendMessages").child(targetUserField.text!.uppercased())
        let receiveMessageUser = userRef.child("receivedMessage").child(plateName).child(targetUserField.text!.uppercased())
        let currentDate = Date()
        let formatDate = DateFormatter()
        formatDate.locale = NSLocale.current
        formatDate.dateFormat = "dd/MM/yyyy HH:mm"
        sendMessageUser.childByAutoId().setValue([  "imageName":self.attachedField.text!,
                                                    "imageUri":imageURL,
                                                    "leido":"No",
                                                    "messageTime":formatDate.string(for: currentDate),
                                                    "messageUserData":self.messageField.text!,
                                                    "subjectUserData":getSubjectData,
                                                    "userPlateData":self.plateName])
       
        receiveMessageUser.childByAutoId().setValue([  "imageName":self.attachedField.text!,
                                                "imageUri":self.imageURL,
                                                "leido":"No",
                                                "messageTime":formatDate.string(for: currentDate),
                                                "messageUserData":self.messageField.text!,
                                                "subjectUserData":getSubjectData,
                                                "userPlateData":self.plateName])
        
        self.showToast(message: self.messageSent, font: .systemFont(ofSize: 14.0))
        setFieldsDisabled()
   }
    
    func setFieldsDisabled() {
        selectSubjectButtom.isEnabled = false
        targetUserField.isEnabled = false
        sendLbl.isEnabled = false
        messageField.isEditable = false
        sendImage.isEnabled = false
        attachedIcon.isEnabled = false
    }
    
    func setFieldsEnabled() {
        selectSubjectButtom.isEnabled = true
        targetUserField.isEnabled = true
        sendLbl.isEnabled = true
        messageField.isEditable = true
        sendImage.isEnabled = true
        attachedIcon.isEnabled = true
    }
    
    func changeLanguage(){
                  
            if (userLanguageSelected == "ES"){
                languages = languageTranslation().spanishLanguage
                selectIssueOptions = languageTranslation().selectNotiIssueES
            }
            if (userLanguageSelected == "EN"){
                languages = languageTranslation().englishLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesEN
            }
            
            if (userLanguageSelected == "FR"){
                languages = languageTranslation().frenchLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesFR
            }
            
            if (userLanguageSelected == "DE"){
                languages = languageTranslation().germanLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesDE
            }
            
            if (userLanguageSelected == "IT"){
                languages = languageTranslation().italianLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesIT 
            }
            
            if (userLanguageSelected == "PT"){
                languages = languageTranslation().portugueseLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesPT
            }
            
            if (userLanguageSelected == "RU"){
                languages = languageTranslation().russianLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesRU
            }
            
            if (userLanguageSelected == "ZH"){
                languages = languageTranslation().chineseLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesZH
            }
            
            if (userLanguageSelected == "JA"){
                languages = languageTranslation().japaneseLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesJA
            }
            
            if (userLanguageSelected == "NL"){
                languages = languageTranslation().dutchLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesNL
            }
            
            if (userLanguageSelected == "PL"){
                languages = languageTranslation().polishLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesPL
            }
            if (userLanguageSelected == "KO"){
                languages = languageTranslation().koreanLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesKO
            }
            
            if (userLanguageSelected == "SV"){
                languages = languageTranslation().swedishLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesSV
            }
            if (userLanguageSelected == "AR"){
                languages = languageTranslation().arabicLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesAR
            }
            if (userLanguageSelected == "UR"){
                languages = languageTranslation().urduLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesUR
            }
            if (userLanguageSelected == "HI"){
                languages = languageTranslation().hindiLanguage
                selectIssueOptions = languageTranslation().selectNotiIssuesHI
            }
        
        selectIssue = languages["selectIssue"]!
        targetUser = languages["targetUser"]!
        targetMessage = languages["targetMessage"]!
        subject = languages["subject"]!
        attached = languages["attached"]!
        message = languages["message"]!
        send = languages["sendText"]!
        sendNotifications = languages["sendNotifications"]!
        targetMessage = languages["targetMessage"]!
        emptyTargetUser = languages["emptyTargetUser"]!
        issueEmpty = languages["issueEmpty"]!
        unregistered_user = languages["unregistered_user"]!
        autoSend = languages["autoSend"]!
        NoMessageSendLockUser = languages["NoMessageSendLockUser"]!
        messageSent = languages["messageSent"]!
        
    }
    

}

extension sendNotification : UITableViewDelegate, UITableViewDataSource {
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
        self.selectSubjectLbl.setTitle(selectedItem, for: UIControl.State.normal)
    }
    
    
    
    
}
