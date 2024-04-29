//
//  About.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 16/8/21.
//

import UIKit
import SafariServices

class About: UIViewController {
    
    var userLanguageSelected : String!
    var languages = languageTranslation().englishLanguage
    var action_about : String!
    var version : String!
    
    
    @IBOutlet weak var pagelbl: UIButton!
    @IBOutlet weak var versionlbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage()
        title = action_about
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionlbl.text = version + ": " + appVersion!
        pagelbl.layer.borderWidth = 0
        

    }
    
    
    @IBAction func pageAction(_ sender: Any) {
        let url = URL(string: "http://www.epicdevelopers.app")
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion:  nil)       
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
        
        action_about = languages["action_about"]!
        version = languages["version"]!
    }
    
}




