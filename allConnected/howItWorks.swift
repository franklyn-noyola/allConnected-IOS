//
//  howItWorks.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 17/8/21.
//

import UIKit

class howItWorks: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shareWith : String!
    var action_about : String!
    var action_contacts : String!
    var searchUser : String!
    var sendNoti : String!
    var action_settings : String!
    var receiveNotification : String!
    var profile_menu : String!
    var chat_menu : String!
    var aboutText : String!
    var receiveText : String!
    var searchText : String!
    var profileText : String!
    var chatText : String!
    var sendNotiText : String!
    var settingText : String!
    var contactText : String!
    var shareText : String!
    var action_howItWorks : String!
    var languages = languageTranslation().spanishLanguage
    var userLanguageSelected : String!
    var headerList : [String] = []
    var bodyList : [String] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage()
        title = action_howItWorks
        if (headerList.count == 0 || headerList.count < 1){
            headerList.append(searchUser)
            bodyList.append(searchText)
            headerList.append(profile_menu)
            bodyList.append(profileText)
            headerList.append(chat_menu)
            bodyList.append(chatText)
            headerList.append(sendNoti)
            bodyList.append(sendNotiText)
            headerList.append(receiveNotification)
            bodyList.append(receiveText)
            headerList.append(action_settings)
            bodyList.append(settingText)
            headerList.append(action_about)
            bodyList.append(aboutText)
            headerList.append(action_contacts)
            bodyList.append(contactText)
            headerList.append(shareWith)
            bodyList.append(shareText)
            
        }
        
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headerList.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "howItWorks", for: indexPath) as! howWorksTableViewCell
        cell.Header.text = headerList[indexPath.row]
        cell.Body.text = bodyList[indexPath.row]
        return cell
    }
    
    private func changeLanguage() {
              
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
        
        shareWith = languages["shareWith"]!
        action_contacts = languages["action_contacts"]!
        searchUser = languages["searchUser"]!
        sendNoti = languages["sendNoti"]!
        action_settings = languages["action_settings"]!
        receiveNotification  = languages["receiveNotification"]!
        profile_menu = languages["profile_menu"]!
        chat_menu = languages["chat_menu"]!
        aboutText = languages["aboutText"]!
        receiveText = languages["receiveText"]!
        searchText = languages["searchText"]!
        profileText = languages["profileText"]!
        chatText  = languages["chatText"]!
        sendNotiText = languages["sendNotiText"]!
        settingText = languages["settingText"]!
        contactText = languages["contactText"]!
        shareText = languages["shareText"]!
        action_howItWorks = languages["action_howItWorks"]!
        action_about = languages["action_about"]!
        
    }
    

}
