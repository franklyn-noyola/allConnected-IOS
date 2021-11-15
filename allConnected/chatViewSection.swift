//
//  chatViewSection.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 12/5/21.
//

import UIKit
import Firebase
import SDWebImage
import MessageKit
import PhotosUI
import InputBarAccessoryView
import FirebaseStorage
import MobileCoreServices

private struct ImageMediaItem : MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    
    init(image: UIImage) {
        self.image = image
        size = CGSize(width: 240, height: 240)
        placeholderImage = UIImage()
    }
    init(imageURL : URL) {
        url = imageURL
        size = CGSize(width: 240, height: 240)
        placeholderImage = UIImage(imageLiteralResourceName: "image_message_placeholder")
    }
}

struct Message: MessageType {
    var sender: SenderType
    var messageId : String
    var sentDate : Date
    var kind: MessageKind
    
    private init (sender: SenderType, messageId: String, sentDate : Date, kind: MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
    }
    
    init(sender: SenderType, messageId: String, sentDate : Date, text: String) {
        self.init(sender: sender, messageId: messageId, sentDate: sentDate, kind: .text(text))
    }
    
    init(sender: SenderType, messageId: String, sentDate : Date, image: UIImage) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(sender: sender, messageId: messageId, sentDate: sentDate, kind: .photo (mediaItem))
    }
}

struct Sender : SenderType {
    var senderId : String
    var displayName: String
}


class chatViewSection: MessagesViewController, UINavigationControllerDelegate  {
    var imageURLV : String!
    var dateData : String!
    var subjectData : String!
    var messageData : String!
    var attachedData : String!
    var msgType: String!
    private var messages : [Message] = []
    var userToChat : String!
    private let storage = Storage.storage().reference()
    var id : String!
    var name : String!
    var mToken : String!
    var textSent : String!
    var messageType : String!
    var plateNumber : String!
    var screenFrom : String!
    var locked : String!
    var dateSent : String!
    var msgDate : String!
    var unlockUser : String!
    var NoMessageSendLockUser : String!
    private let selfSender = Sender(senderId: "9876JCX",
    displayName: "Franklyn Noyola")
    var userChat : String!
    var blockUserImage : UIImage!
    var userLanguageSelected : String!
    var chatFrom : String!
    var messageText : String!
    var userRef : DatabaseReference!
    var messageTimeFrom: String!
    var MessageTimeTo : String!
    var yes : String!
    var No : String!
    var lockUser : String!
    var picture = UIButton(type: UIButton.ButtonType.custom)
    var camera = UIButton(type: UIButton.ButtonType.custom)
    var blockUserButton = UIBarButtonItem()
    var delChatButton  = UIBarButtonItem()
    var lockedUserMsg : String!
    var unlockUserMsg  : String!
    var deleteChatMsg  : String!
    var blocked : Bool = false
    var deleteChatMenu : String!
    var imageURL : UIImage!
    var back : String!
    var chatdeleted : String!
    var blockingUser : String!
    
    private func delChatUser() {
        let delChat = userRef.child("Chat").child(plateNumber).child(userToChat)
        delChat.observeSingleEvent(of: .value, with: {(snapshot) in
            delChat.removeValue()
        })
    }
        
    private func delChatList() {
        let delChat = userRef.child("Chat").child("listChatUsers").child(plateNumber)
        let delChatQuery = delChat.queryOrdered(byChild: "userToChat").queryEqual(toValue:  userChat)
        delChatQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            var key : String!
            if (snapshot.exists()){
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    key = snap.key
                }
                delChat.child(key).removeValue()
            }
        })
    }

    private func getBlockedUser() {
        let blockUser = userRef.child("BlockUsers").child(plateNumber).child(userToChat)
        let blockUserQuery = blockUser.queryOrdered(byChild: "Blocked").queryEqual(toValue:  "Si")
        blockUserQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                print("User Blocked")
                self.title! = self.userToChat + " - " + self.locked
                self.blockUserImage = UIImage(systemName: "lock.fill")!
            
            }else{
                self.blockUserImage = UIImage(systemName: "lock.open.fill")!
                self.title! = self.userToChat
            }
            let deleteChatImage = UIImage(systemName: "trash")!
           
            self.blockUserButton = UIBarButtonItem(image: self.blockUserImage, style: .plain, target: self, action:  #selector(self.blockUserAction))
            
            self.delChatButton = UIBarButtonItem(image: deleteChatImage, style: .plain, target: self, action: #selector(self.delChatAction))
            
            self.navigationItem.rightBarButtonItems = [self.delChatButton, self.blockUserButton]
        })
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        userRef = Database.database().reference()
        self.tabBarController?.tabBar.isHidden = true
        changeLanguage()
        userChat = userToChat
        getBlockedUser()
        setUpMessageView()
        removeMessageAvatars()
        changeButton()
        addPictureButton()
        
        let chatSet = userRef.child("Chat").child(plateNumber).child(userToChat)
        chatSet.observe(.childAdded, with: { [weak self] snapshot  in
            
            if let data = snapshot.value as? [String: String],
               let id = data["chatFrom"],
               let name = data["messageTimeFrom"],
               let textSent = data["messageText"],
               let messageType = data["messageType"],
               !textSent.isEmpty
               {
                let selfSender = Sender(senderId: id, displayName: name)
                var sendMessage = Message(sender: selfSender,
                                        messageId: "1",
                                        sentDate: Date(),
                                        text: textSent)
            
                
                if (messageType == "text"){
                    sendMessage = Message(sender: selfSender,
                                            messageId: "1",
                                            sentDate: Date(),
                                            text: textSent)
                }
                
                if (messageType == "image") {
                    
                    let getURL = NSURL(string: textSent)! as URL
                    if let imageData : NSData = NSData(contentsOf: getURL) {
                        self?.imageURL = UIImage(data : imageData as Data)
                    }
                    sendMessage = Message(sender: selfSender,
                                          messageId:  "1",
                                          sentDate: Date(),
                                          image: (self?.imageURL)!)
                    
                }
                self?.insertMessage(sendMessage)
             }
            })
    }
    
    private func changeButton() {
        messageInputBar.sendButton.title = ""
        messageInputBar.sendButton.setBackgroundImage(UIImage(named: "sendIcon"), for: UIControl.State.normal)
    }
    
    private func addPictureButton() {
        let items = [
            makeButton(named: "photo.fill").onSelected {
                [weak self] item in guard let self = self else {return}
                self.selectImage()
            },
            .flexibleSpace,
            makeButton(named: "camera.fill").onSelected {
                [weak self] item in guard let self = self else {return}
                self.takeImage()
            }
        ]
        messageInputBar.delegate = self
        messageInputBar.leftStackView.alignment = .fill
        messageInputBar.setLeftStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.setStackViewItems(items, forStack: .bottom, animated: false)
    }
    
    func takeImage() {
        if (self.title!.contains(self.locked)){
            showToast(message: NoMessageSendLockUser, font: .systemFont(ofSize: 13.0))
            return
        }else{
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .camera
            pickerVC.modalPresentationStyle = .fullScreen
            pickerVC.allowsEditing = true
            present(pickerVC, animated: true, completion: nil)
        }
    }
    
    func selectImage() {
        if (self.title!.contains(self.locked)){
            showToast(message: NoMessageSendLockUser, font: .systemFont(ofSize: 13.0))
            return
        }else{
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .photoLibrary
            pickerVC.modalPresentationStyle = .fullScreen
            pickerVC.allowsEditing = true
            present(pickerVC, animated: true, completion: nil)
        }
    }
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(systemName: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 50, height: 50), animated: false)
            }
    }
    
    private func sendImage(_ image : UIImage) {
        do {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let uploadData = image.jpegData(compressionQuality: 0.5)
            let chatSet1 = userRef.child("Chat").child(plateNumber).child(userChat)
            let idImage = chatSet1.childByAutoId().key
            let imageName = plateNumber + idImage! + ".jpg"
            let imageReference = Storage.storage().reference().child("Imagenes/"+imageName)
            imageReference.putData(uploadData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print ("Upload error: \(error.localizedDescription)")
                    return
                }
                imageReference.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print("Error on getting download url: \(error.localizedDescription)")
                        return
                    }
                    self.textSent = url!.absoluteString
                    let currentDate = Date()
                    let formatDate = DateFormatter()
                    formatDate.locale = NSLocale.current
                    formatDate.dateFormat = "dd/MM/yyyy HH:mm"
                    self.msgDate = formatDate.string(from: currentDate)
                    self.msgType = "image"
                    self.saveChatData()
                    self.setListChatUser()
                    self.setListChatUser2()
                })
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker : UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            sendImage(image)
        }else {
            return
        }
          picker.dismiss(animated: true, completion: nil)
        
    }
    
    func isLastSectionVisible() -> Bool {
        guard !messages.isEmpty else {
            return false}
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    @objc private func blockUserAction() {
        let alert:UIAlertController
        
        if (self.title!.contains(self.locked)) {
            alert = UIAlertController(title: unlockUser, message: unlockUserMsg, preferredStyle: UIAlertController.Style.alert)
           
        }else {
            alert = UIAlertController(title: lockUser, message: lockedUserMsg, preferredStyle: UIAlertController.Style.alert)
            
        }
        alert.addAction(UIAlertAction(title: yes, style: UIAlertAction.Style.default) {_ in
            if (self.title!.contains(self.locked)){
                self.title = self.userToChat
                self.blockingUser = "No"
                self.blockUserImage = UIImage(systemName: "lock.open.fill")!
            }else {
                self.title = self.userToChat + " - " + self.locked
                self.blockUserImage = UIImage(systemName: "lock.fill")!
                self.blockingUser = "Si"
            }
            self.setBlockUser()
            self.setBlockUserListUser()
            self.blockUserButton = UIBarButtonItem(image: self.blockUserImage, style: .plain, target: self, action:  #selector(self.blockUserAction))
            self.navigationItem.rightBarButtonItems = [self.delChatButton, self.blockUserButton]
        })
        alert.addAction(UIAlertAction(title: No, style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setBlockUser() {
        let blockUser = userRef.child("BlockUsers").child(plateNumber).child(userToChat)
        blockUser.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                var key : String = ""
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    key = snap.key
                }
                self.userRef.child("BlockUsers").child(self.plateNumber).child(self.userToChat).child(key).updateChildValues(["Blocked": self.blockingUser!])
            }else {
                self.userRef.child("BlockUsers").child(self.plateNumber).child(self.userToChat).childByAutoId().setValue(["Blocked": "Si"])
            }
        })
    }
    
    @objc private func delChatAction() {
        let alert = UIAlertController(title: deleteChatMenu, message: deleteChatMsg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: yes, style: UIAlertAction.Style.default) { _ in
            self.delChatList()
            self.delChatUser()
            self.showToast(message: self.chatdeleted, font: .systemFont(ofSize: 13.0))
            if self.screenFrom == "0" {
            let goChat = (self.storyboard?.instantiateViewController(identifier: "chatSB")) as! chatController
            goChat.userLanguageSelected = self.userLanguageSelected
                goChat.plateName = self.plateNumber
                self.navigationController?.pushViewController(goChat, animated: false)
                
            }
            if self.screenFrom == "1" {
                let goChat = (self.storyboard?.instantiateViewController(identifier: "ProfileViewSB")) as! profileViewControler
                goChat.userLanguageSelected = self.userLanguageSelected
                goChat.plateName = self.plateNumber
                self.navigationController?.pushViewController(goChat, animated: false)
                
            }
            if self.screenFrom == "2" {
                let goChat = (self.storyboard?.instantiateViewController(identifier: "viewNotification")) as! viewNotification
                let backButtom = UIBarButtonItem()
                backButtom.title = self.back
                self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButtom
                goChat.userLanguageSelected = self.userLanguageSelected
                goChat.plateName = self.plateNumber
                goChat.fromScreen = "1"
                goChat.plateNumber = self.userToChat
                goChat.imageURL = self.imageURLV
                goChat.dateData = self.dateData
                goChat.subjectData = self.subjectData
                goChat.messageData = self.messageData
                goChat.attachedData = self.attachedData
                self.navigationController?.pushViewController(goChat, animated: false)
                
                
            }
            
            
        })
        alert.addAction(UIAlertAction(title: No, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
     textSent = text
     let currentDate = Date()
     let formatDate = DateFormatter()
     formatDate.locale = NSLocale.current
     formatDate.dateFormat = "dd/MM/yyyy HH:mm"
     msgDate = formatDate.string(from: currentDate)
        msgType = "text"
        if (self.title!.contains(self.locked)){
            showToast(message: NoMessageSendLockUser, font: .systemFont(ofSize: 13.0))
            return
        }else{
                saveChatData()
                setListChatUser2()
                setListChatUser()
                inputBar.inputTextView.text = ""
        }
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    private func saveChatData(){
        
        let blockUser = userRef.child("BlockUsers").child(userToChat).child(plateNumber)
        let blockUserQuery = blockUser.queryOrdered(byChild: "Blocked").queryEqual(toValue:  "Si")
        let chatSet1 = userRef.child("Chat").child(plateNumber).child(userChat)
        let chatSet2 = userRef.child("Chat").child(userChat).child(plateNumber)
      
        blockUserQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if (snapshot.exists()){
                chatSet1.childByAutoId().setValue(["chatFrom": self.plateNumber,
                                                   "messageText": self.textSent,
                                                   "messageTimeFrom": self.msgDate,
                                                   "messageTimeTo": self.msgDate,
                                                   "messageType": self.msgType])
                return
            }else{
                chatSet1.childByAutoId().setValue(["chatFrom": self.plateNumber,
                                                   "messageText": self.textSent,
                                                   "messageTimeFrom": self.msgDate,
                                                   "messageTimeTo": self.msgDate,
                                                   "messageType": self.msgType])
                
                chatSet2.childByAutoId().setValue(["chatFrom": self.plateNumber,
                                                   "messageText": self.textSent,
                                                   "messageTimeFrom": self.msgDate,
                                                   "messageTimeTo": self.msgDate,
                                                   "messageType": self.msgType])
            }
            
        })
        
       }
    
    private func setListChatUser() {
        let listOfChats = userRef.child("Chat").child("listChatUsers").child(plateNumber)
        let listQuery = listOfChats.queryOrdered(byChild: "userToChat").queryEqual(toValue: userChat)
        listQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()) {
                var key : String = ""
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    key = snap.key
                }
                
                self.userRef.child("Chat").child("listChatUsers").child(self.plateNumber).child(key).updateChildValues(["messageText" : self.textSent!,
                                                "messageTime" : self.msgDate!,
                                                "blockedUs" : "No",
                                                "messageType" : self.msgType!])
            }else {
                self.userRef.child("Chat").child("listChatUsers").child(self.plateNumber).childByAutoId().setValue(["messageText" : self.textSent,
                                       "messageTime" : self.msgDate,
                                       "userToChat" : self.userChat,
                                       "blockedUs" : "No",
                                       "messageType" : self.msgType])
            }
            
        })
    }
    
     private func setListChatUser2() {
        let listOfChats = userRef.child("Chat").child("listChatUsers").child(userChat)
        let listQuery = listOfChats.queryOrdered(byChild: "userToChat").queryEqual(toValue: plateNumber)
        if (self.title!.contains(self.locked)){
            return
        }else{
            listQuery.observeSingleEvent(of: .value, with: {(snapshot) in
                    var key : String = ""
                    if (snapshot.exists()) {
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        key = snap.key
                    }
                    self.userRef.child("Chat").child("listChatUsers").child(self.userChat).child(key).updateChildValues(["messageText" : self.textSent!,                                             "messageTime" : self.msgDate!,
                                                    "messageType" : self.msgType!])
                    }else {
                        self.userRef.child("Chat").child("listChatUsers").child(self.userChat).childByAutoId().setValue(["messageText" : self.textSent,
                                               "userToChat"  : self.plateNumber,
                                               "messageTime" : self.msgDate,
                                               "blockedUs" : "",
                                               "messageType" : self.msgType])
                    }
                })
            }
    }
    
    private func setBlockUserListUser() {
        let listOfChats = userRef.child("Chat").child("listChatUsers").child(plateNumber)
        let blockUser = listOfChats.queryOrdered(byChild: "userToChat").queryEqual(toValue: userToChat)
        blockUser.observeSingleEvent(of: .value, with: {(snapshot) in
            var key : String = ""
            if (snapshot.exists()) {
                for child in snapshot.children {
                   let snap = child as! DataSnapshot
                    key = snap.key
                }
                self.userRef.child("Chat").child("listChatUsers").child(self.plateNumber).child(key).updateChildValues(["blockedUs":self.blockingUser])
            }
        })
        
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
        lockedUserMsg = languages["lockedUserMsg"]!
        unlockUserMsg = languages["unlockUserMsg"]!
        deleteChatMsg = languages["deleteChatMsg"]!
        deleteChatMenu = languages["deleteChatMenu"]!
        yes = languages["yes"]!
        No = languages["No"]!
        lockUser = languages["lockUser"]!
        unlockUser = languages["unlockUser"]!
        locked = languages["locked"]!
        chatdeleted = languages["chatdeleted"]!
        back = languages["back"]!
        NoMessageSendLockUser = languages["NoMessageSendLockUser"]!
        
    }
    
    private func removeMessageAvatars() {
        guard
            let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        else {
            return
        }
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        layout.setMessageIncomingAvatarSize(.zero)
        layout.setMessageOutgoingAvatarSize(.zero)
        let incomingLabelAlignment = LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top:0,left:15,bottom:0,right:0))
        layout.setMessageIncomingMessageTopLabelAlignment(incomingLabelAlignment)
        let outcomingLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top:0,left:0,bottom:0,right:15))
        layout.setMessageOutgoingMessageTopLabelAlignment(outcomingLabelAlignment)
    }
    
    private func setUpMessageView() {
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource=self
        messagesCollectionView.messagesLayoutDelegate=self
        messagesCollectionView.messagesDisplayDelegate=self
        messagesCollectionView.messageCellDelegate = self
    }
    

    private func insertMessage (_ message: Message) {
        messages.append(message)
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
            
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
}
  
extension chatViewSection : MessagesDataSource, MessageLabelDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate, MessagesLayoutDelegate, UIImagePickerControllerDelegate, MessageCellDelegate {
    func currentSender() -> SenderType {
        return Sender(senderId: plateNumber, displayName: "Franklyn Noyola")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)])
        }
    
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = false
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .lightGray
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner =
            isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {return}
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {return}
        let messageImg = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        switch messageImg.kind {
            case .photo(let photoItem) :
                let newImageView =  UIImageView (image: photoItem.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissImageScreen))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
                messageInputBar.isHidden = true
        default:
            break
            
        }
    }
    
    @objc func dismissImageScreen(_ sender: UITapGestureRecognizer) {
        messageInputBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        sender.view?.removeFromSuperview()
    }
    
}


