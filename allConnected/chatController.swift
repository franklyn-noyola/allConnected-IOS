//
//  chatController.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 27/4/21.
//

import UIKit
import Firebase

class chatController: UIViewController, UIGestureRecognizerDelegate {
 
    var users : [listSectionInit] = []
    var plateNumberName : String!
    var mToken : String!
    var numberOfPlate : String!
    var userLanguageSelected : String!
    var noEmptySearch : String!
    var chat : String!
    var deleteChatMsg : String!
    var delete_chat : String!
    var settings : String!
    var locked : String!
    var cel : String!
    var about : String!
    var contact : String!
    var userSelf : String!
    var howItWorks : String!
    var photo : String!
    var noExists : String!
    var logout : String!
    var userRef : DatabaseReference!
    var yesButtonLbl : String!
    var noButtonLbl : String!
    var logoutText : String!
    var plateName : String!
    var searchUserText : String!
    var chatdeleted : String!
    var shareWith : String!
    var languages = languageTranslation().englishLanguage

    @IBOutlet weak var listUser: UITableView!
    @IBOutlet weak var searchUser: UISearchBar!
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        userRef = Database.database().reference()
        changelanguage()
        self.navigationItem.title = chat
        configFields()
        
        listUser.delegate = self
        listUser.dataSource = self

        getUserListData()
        
        listUser.reloadData()
              
        listUser.separatorColor = UIColor.cyan
        
        setupMenu(settings, about, contact, howItWorks, shareWith, logout, yesButtonLbl, noButtonLbl, logoutText, userLanguageSelected, plateName, screen: "2")
    }

    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func delChatList() {
        
        let delChat = userRef.child("Chat").child("listChatUsers").child(plateName)
        let delChatQuery = delChat.queryOrdered(byChild: "userToChat").queryEqual(toValue:  numberOfPlate)
        delChatQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            var key : String = ""
            if (snapshot.exists()){
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    key = snap.key
                }
                
                delChat.child(key).removeValue()
            }
            
        })
        
    }
    
    private func delChatUser() {
        let delChat = userRef.child("Chat").child(plateName).child(numberOfPlate)
        delChat.observeSingleEvent(of: .value, with: {(snapshot) in
            delChat.removeValue()
           
        })
        
    }
        
    func configFields() {
        searchButton.setTitle(searchUserText, for: UIControl.State.normal)
        searchButton.layer.cornerRadius = 8
    }
    
    func getUserListData() {
        var message : String = ""
        var plateUser : String = ""
        let getUserList = userRef.child("Chat").child("listChatUsers").child(plateName)
        var userPost : [listSectionInit] = []
        getUserList.observe(.value, with:  {(snapshot) in
            var getPlate : [String] = []
            var i : Int = 0
            var getMessage : [String] = []
            var type : [String] = []
            var time : [String] = []
            var blocked : [String] = []
            for child in snapshot.children {
                let dataChild = child as! DataSnapshot
                let data = dataChild.value as! [String : Any]
                getPlate.append(data["userToChat"] as? String ?? "")
                getMessage.append(data["messageText"] as? String ?? "")
                type.append(data["messageType"] as? String ?? "")
                time.append(data["messageTime"] as? String ?? "")
                blocked.append(data["blockedUs"] as? String ?? "")
            }
            userPost.removeAll()
            while i < snapshot.childrenCount {
                message = getMessage[i]
                if (type[Int(i)] == "image") {
                        message = self.photo
                }
                if (blocked[Int(i)] == "Si") {
                    plateUser = getPlate[i] + " - " + self.locked
                }else {
                    plateUser = getPlate[i]
                }
                let users = listSectionInit(plate: plateUser, date : time[Int(i)], body : message, messageType: type[Int(i)], blocked: blocked[i])
            userPost.insert(users, at: 0)
                i += 1
                self.users = userPost
                
            }
            self.listUser.reloadData()
                  
        })
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if (searchUser.text!.uppercased() == plateName) {
            showToast(message: userSelf, font: .systemFont(ofSize: 9.0))
            return
        }
        
        if (searchUser.text?.isEmpty == true) {
            showToast(message: noEmptySearch, font: .systemFont(ofSize: 12.0))
            return
        }
        
        
        let userQuery = userRef.child("Users")
        let getSearch = userQuery.queryOrdered(byChild: "plate_user").queryEqual(toValue: searchUser.text!.uppercased())
        getSearch.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                let goChat = self.storyboard?.instantiateViewController(identifier: "chatView") as! chatViewSection
                       
                self.navigationController?.pushViewController(goChat, animated: true)
               
                goChat.userLanguageSelected=self.userLanguageSelected.uppercased()
                goChat.userToChat=self.searchUser.text!.uppercased()
                goChat.plateNumber=self.plateName
                goChat.screenFrom = "0"
                goChat.mToken = self.mToken
            }else{
                self.showToast(message: self.noExists, font: .systemFont(ofSize: 14.0))
            }
        })
        
    }
    
     func changelanguage(){
    if (userLanguageSelected == "ES"){
        languages = languageTranslation().spanishLanguage
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
      
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
    chat = languages["chat_menu"]!
    settings = languages["action_settings"]!
    about = languages["action_about"]!
    contact = languages["action_contacts"]!
    howItWorks = languages["action_howItWorks"]!
    logout = languages["logout_menu"]!
    yesButtonLbl = languages["yes"]!
    noButtonLbl = languages["No"]!
    logoutText = languages["logout"]!
    noExists = languages["noExists"]!
    userSelf = languages["userSelf"]!
    photo = languages["photo"]!
    searchUserText = languages ["searchUser"]!
    noEmptySearch = languages["noEmptySearch"]!
    delete_chat = languages["delete_chat"]!
    deleteChatMsg = languages["deleteChatMsg"]!
    chatdeleted = languages["chatdeleted"]!
    shareWith = languages["shareWith"]!
    locked = languages["locked"]!
        

}
    
}

extension chatController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        listUser.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let users = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listUser") as! listUserSection
        
        cell.getDataUser(data: users)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let plateNumber = listUser.cellForRow(at: indexPath) as! listUserSection
        plateNumberName = plateNumber.plateNameField!.text!
        if plateNumberName.contains("-") {
            let range : Range<String.Index> = plateNumberName.range(of: "-")!
            let index : Int = plateNumberName.distance(from: plateNumberName.startIndex, to: range.lowerBound)
            numberOfPlate = String(plateNumberName.prefix(index-1))
        }else {
            numberOfPlate = plateNumber.plateNameField!.text!
        }
        
        let goChat = storyboard?.instantiateViewController(identifier: "chatView") as! chatViewSection
        goChat.userLanguageSelected = self.userLanguageSelected.uppercased()
        goChat.userToChat = numberOfPlate
        goChat.plateNumber = self.plateName
        
        self.navigationController?.pushViewController(goChat, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let plateNumber = listUser.cellForRow(at: indexPath) as! listUserSection
        plateNumberName = plateNumber.plateNameField!.text!
        if plateNumberName.contains("-") {
            let range : Range<String.Index> = plateNumberName.range(of: "-")!
            let index : Int = plateNumberName.distance(from: plateNumberName.startIndex, to: range.lowerBound)
            numberOfPlate = String(plateNumberName.prefix(index-1))
        }else {
            numberOfPlate = plateNumber.plateNameField!.text!
        }
        
        let delChat = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let del = UIAction(title: self.delete_chat, image: UIImage(systemName: "trash")) { _ in
                let alert = UIAlertController(title: self.delete_chat, message: self.deleteChatMsg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: self.yesButtonLbl, style: UIAlertAction.Style.default) {_ in
                    self.delChatList()
                    self.delChatUser()
                    self.showToast(message: self.chatdeleted, font: .systemFont(ofSize: 12.0))
                })
                alert.addAction(UIAlertAction(title: self.noButtonLbl, style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true)
            }
            let menuDel = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [del])
            return menuDel
        }
        return delChat
    }
 }
