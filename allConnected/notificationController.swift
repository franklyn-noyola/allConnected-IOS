//
//  notificationController.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 27/4/21.
//

import UIKit
import Firebase

class notificationController: UIViewController, UIGestureRecognizerDelegate {
    
    
    var plateName : String!
    var getTime : String!
    var back : String!
    var del_notification : String!
    var delete_notification: String!
    var notificationDeleted: String!
    var userLanguageSelected : String!
    var listNotification : [notiListInit] = []
    var noNotificationsLbl : String!
    var getPlate : [String] = []
    var i : Int = 0
    var getMessage : [String] = []
    var read : [String] = []
    var time : [String] = []
    var subject : [String] = []
    var getAttached : [String] = []
    var getImage : [String] = []
    var from : String!
    var subjectL : String!
    var message  : String!
    var attached  : String!
    @IBOutlet weak var NotificationList: UITableView!
    @IBOutlet weak var noNotifications: UILabel!
    var notification : String!
    var settings : String!
    var about : String!
    var sendNoti : String!
    var contact : String!
    var howItWorks : String!
    var logout : String!
    var shareWith : String!
    var yesButtonLbl : String!
    var noButtonLbl : String!
    var logoutText : String!
    var mToken : String!
    var userRef : DatabaseReference!
    
  
    @IBOutlet weak var sendNotiButton: UIButton!
    
 
    
    var languages = languageTranslation().englishLanguage

    override func viewDidLoad() {
        super.viewDidLoad()
        changelanguage()
        setupMenu(settings, about, contact, howItWorks, shareWith, logout, yesButtonLbl, noButtonLbl, logoutText, userLanguageSelected, plateName, screen: "3")
        self.hideKeyboardWhenTappedAround()
        sendNotiButton.setTitle(sendNoti, for: UIControl.State.normal)
        sendNotiButton.layer.cornerRadius = 8
        userRef = Database.database().reference()
        NotificationList.delegate = self
        NotificationList.dataSource = self
        noNotifications.text = noNotificationsLbl
        getNotificationList()
        NotificationList.reloadData()
        NotificationList.separatorColor = UIColor.cyan
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        listNotification.removeAll()
        getNotificationList()
        NotificationList.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        listNotification.removeAll()
        getNotificationList()
        NotificationList.reloadData()
        
    }
    
    func deleteNotification () {
        let notiListData = userRef.child("sendMessages").child(plateName)
        let listQuery = notiListData.queryOrdered(byChild: "messageTime").queryEqual(toValue: getTime)
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
    }
    
    func getNotificationList() {
        var listPost : [notiListInit] = []
        let notiListData = userRef.child("sendMessages").child(plateName)
        notiListData.observe(.value, with:  {(snapshot) in
           if (snapshot.exists()) {
               listPost.removeAll()
            self.NotificationList.isHidden = false
            self.noNotifications.isHidden = true
                for child in snapshot.children {
                    let dataChild = child as! DataSnapshot
                    let data = dataChild.value as! [String : Any]
                    
                    let list = notiListInit(plate : data["userPlateData"] as? String ?? "", date : data["messageTime"] as? String ?? "", read : data["leido"] as? String ?? "", subject : data["subjectUserData"] as? String ?? "", message : data["messageUserData"] as? String ?? "", attached : data["imageName"] as? String ?? "", fromLbl : self.from, subjectLbl : self.subjectL, messageLbl : self.message, attachedLbl : self.attached, imageURL : data["imageUri"] as? String ?? "")
                    listPost.insert(list, at: 0)
                    
                }
                self.listNotification = listPost
                self.NotificationList.reloadData()
           } else {
            self.NotificationList.isHidden = true
            self.noNotifications.isHidden = false
           }
        })
        
    }
    
    @IBAction func sendNotiAction(_ sender: Any) {
      let goSendNotification = storyboard?.instantiateViewController(identifier: "sendNotification") as! sendNotification
        
        goSendNotification.userLanguageSelected = self.userLanguageSelected.uppercased()
        goSendNotification.plateName = plateName
        goSendNotification.fromScreen = "1"
        self.navigationController?.pushViewController(goSendNotification, animated: true)
        
    }
    
    func changelanguage(){
    if (userLanguageSelected == "ES"){
        languages = languageTranslation().spanishLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
      
    }
    if (userLanguageSelected == "EN"){
        languages = languageTranslation().englishLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "FR"){
        languages = languageTranslation().frenchLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold) ]
    }
    if (userLanguageSelected == "DE"){
        languages = languageTranslation().germanLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "IT"){
        languages = languageTranslation().italianLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "PT"){
        languages = languageTranslation().portugueseLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "RU"){
        languages = languageTranslation().russianLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "ZH"){
        languages = languageTranslation().chineseLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "JA"){
        languages = languageTranslation().japaneseLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "NL"){
        languages = languageTranslation().dutchLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "PL"){
        languages = languageTranslation().polishLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "KO"){
        languages = languageTranslation().koreanLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "SV"){
        languages = languageTranslation().swedishLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "AR"){
        languages = languageTranslation().arabicLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "UR"){
        languages = languageTranslation().urduLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold) ]
    }
    
    if (userLanguageSelected == "HI"){
        languages = languageTranslation().hindiLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: UIFont.Weight.bold) ]
    }
    notification = languages["receivedNotifications"]!
    settings = languages["action_settings"]!
    about = languages["action_about"]!
    contact = languages["action_contacts"]!
    howItWorks = languages["action_howItWorks"]!
    logout = languages["logout_menu"]!
    yesButtonLbl = languages["yes"]!
    noButtonLbl = languages["No"]!
    logoutText = languages["logout"]!
    shareWith = languages["shareWith"]!
    sendNoti = languages["sendNoti"]!
    noNotificationsLbl = languages["noNotifications"]!
    from = languages["from"]!
    subjectL = languages["subject"]!
    message = languages["message"]!
    attached = languages["attached"]!
    delete_notification = languages["delete_notification"]!
    del_notification = languages["del_notification"]!
    notificationDeleted = languages["notificationDeleted"]!
        back = languages["back"]!
        self.navigationItem.title = notification
    }
    
}

extension notificationController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listNotification.count
    }
    
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        //NotificationList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listNoti = listNotification[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notiList") as! notiListSection
        
        cell.getNotiList(data: listNoti)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let notiTime = NotificationList.cellForRow(at: indexPath) as! notiListSection
        getTime = notiTime.dateField.text!
        
        
        
        let delNotification = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let del = UIAction(title: self.del_notification, image: UIImage(systemName: "trash")) { _ in
                let alert = UIAlertController(title: self.del_notification, message: self.delete_notification, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: self.yesButtonLbl, style: UIAlertAction.Style.default) {_ in
                    self.deleteNotification()
                    
                    self.showToast(message: self.notificationDeleted, font: .systemFont(ofSize: 12.0))
                })
                alert.addAction(UIAlertAction(title: self.noButtonLbl, style: UIAlertAction.Style.cancel, handler: nil))
                print(self.getTime!)
                self.present(alert, animated: true)
            }
            let menuDel = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [del])
            return menuDel
        }
        return delNotification
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notificationData = NotificationList.cellForRow(at: indexPath) as! notiListSection
      
        
        let goViewNotification = storyboard?.instantiateViewController(identifier: "viewNotification") as! viewNotification
        
        goViewNotification.userLanguageSelected = self.userLanguageSelected.uppercased()
        
        goViewNotification.title = notificationData.plateName.text! + "-" + notificationData.subjectField.text!
        goViewNotification.imageURL = notificationData.imageURL.text!
        goViewNotification.plateNumber = notificationData.plateName.text!
        goViewNotification.dateData = notificationData.dateField.text!
        goViewNotification.subjectData = notificationData.subjectField.text!
        goViewNotification.messageData = notificationData.messageField.text!
        goViewNotification.attachedData = notificationData.attachedField.text!
        goViewNotification.plateName = plateName
        goViewNotification.fromScreen = "0"
        let backItem = UIBarButtonItem()
        backItem.title = back
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(goViewNotification, animated: true)
        
    }
    
    
}

