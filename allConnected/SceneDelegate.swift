//
//  SceneDelegate.swift
//  allConnected2
//
//  Created by Franklyn Garcia Noyola on 10/4/21.
//

import UIKit
import Firebase




class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var getHome : String = "ON"
    var mToken : String = ""
    var hometab : String = ""
    var languages = languageTranslation().englishLanguage
   
    var userRef : DatabaseReference!
    var userLanguage : String = ""
    var profileTab : String = ""
    var chatTab : String = ""
    var notificationsTab : String = ""
    	
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        userRef = Database.database().reference()
        
        Messaging.messaging().token {token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }else if let token = token{
                print ("FCM registration token: \(token)")
                self.mToken = token
                self.getLanguageUser(self.mToken)
              }
            print ("Este es el token: " + self.mToken)
        }
      
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
       
    }
    
     
   
    
    func getUserTab(_ user : String, _ mToken : String, _ language : String) {
        userLanguage = language.uppercased()
        changeLanguage()
        let token = mToken
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if (getHome=="ON") {
            let homeTab = storyboard.instantiateViewController(identifier: "homeTab") as UITabBarController
            window?.rootViewController = homeTab
              let profileSBVC = homeTab.viewControllers?[0] as! UINavigationController
              let profileView = profileSBVC.topViewController as! profileViewControler
              let profileSectionV = homeTab.viewControllers?[1] as! UINavigationController
              let profileSection = profileSectionV.topViewController as! profileSection
            let chatSectionV = homeTab.viewControllers?[2] as! UINavigationController
            let chatSection = chatSectionV.topViewController as! chatController
            let notificationV = homeTab.viewControllers?[3] as! UINavigationController
            let notification = notificationV.topViewController as! notificationController
                profileView.tabBarItem.title = hometab
                profileView.plateName = user
                profileView.mToken = token
                profileView.userLanguageSelected = self.userLanguage.uppercased()
                profileSection.plateName = user
                profileSection.tabBarItem.title = profileTab
                profileSection.userLanguageSelected = self.userLanguage.uppercased()
                chatSection.plateName = user
                chatSection.tabBarItem.title = chatTab
                chatSection.userLanguageSelected = self.userLanguage.uppercased()
                chatSection.mToken = token
                notification.plateName = user
                notification.mToken = token
                notification.tabBarItem.title = notificationsTab
                notification.userLanguageSelected = self.userLanguage.uppercased()
            
            
        }else{
            let mainControl = storyboard.instantiateViewController(identifier: "mainController") as UINavigationController
            window?.rootViewController = mainControl
            let mainContoller = mainControl.topViewController as! ViewController
            mainContoller.userDefaultLanguage = self.userLanguage.uppercased()
            mainContoller.mToken = token

            
        }
    }
    
    private func getUserActive(_ mToken : String, _ language : String){
        let token = mToken
        
        let userRefQuery = userRef.child("activeSession").child(mToken)
        let query = userRefQuery.queryOrdered(byChild: "active").queryEqual(toValue: "ON")
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            var userActive : String = ""
            if (snapshot.exists()) {
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let active = snap.value as! [String : Any]
                    userActive = active["activeUser"] as? String ?? ""
                }
                self.getHome = "ON"
            
            }else{
                self.getHome = "OFF"
            }
            self.getUserTab(userActive, token, language)
        })
    }
    
    func getLanguageUser(_ mToken : String){
        var userLang : String = ""
        let userRefQuery = userRef.child("Users").child("userLanguage")
        let query = userRefQuery.queryOrdered(byChild: "users").queryEqual(toValue: mToken)
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let language = snap.value as! [String : Any]
                    userLang = language["language"] as? String ?? ""
                }
                   self.userLanguage = userLang
                
            }else{
                self.userLanguage = Locale.current.languageCode!
            }
            self.getUserActive(mToken, self.userLanguage)
        
        })
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true){
        guard let window = self.window else{
            return
        }
        window.rootViewController = vc
    }
    
    func changeLanguage(){
              
        if (userLanguage == "ES"){
            languages = languageTranslation().spanishLanguage
        
        }
        if (userLanguage == "EN"){
            languages = languageTranslation().englishLanguage
        }
        
        if (userLanguage == "FR"){
            languages = languageTranslation().frenchLanguage
        }
        
        if (userLanguage == "DE"){
            languages = languageTranslation().germanLanguage
        }
        
        if (userLanguage == "IT"){
            languages = languageTranslation().italianLanguage
        }
        
        if (userLanguage == "PT"){
            languages = languageTranslation().portugueseLanguage
        }
        
        if (userLanguage == "RU"){
            languages = languageTranslation().russianLanguage
        }
        
        if (userLanguage == "ZH"){
            languages = languageTranslation().chineseLanguage
        }
        
        if (userLanguage == "JA"){
            languages = languageTranslation().japaneseLanguage
        }
        
        if (userLanguage == "NL"){
            languages = languageTranslation().dutchLanguage
        }
        
        if (userLanguage == "PL"){
            languages = languageTranslation().polishLanguage
        }
        if (userLanguage == "KO"){
            languages = languageTranslation().koreanLanguage
        }
        
        if (userLanguage == "SV"){
            languages = languageTranslation().swedishLanguage
        }
        if (userLanguage == "AR"){
            languages = languageTranslation().arabicLanguage
        }
        if (userLanguage == "UR"){
            languages = languageTranslation().urduLanguage
        }
        if (userLanguage == "HI"){
            languages = languageTranslation().hindiLanguage
        }
        profileTab = self.languages["profile_menu"]!
        chatTab = self.languages["chat_menu"]!
        hometab = self.languages["home_menu"]!
        notificationsTab = self.languages["receivedNotifications"]!
    }


}

extension UIViewController {
               
 
    struct defaultLanguage
    {
        static var userLanguage : String = ""
        static var logoutLabel : String = ""
        static var YesButton : String = ""
        static var NoButton : String = ""
        static var mToken : String = ""
        static var auxMenu = UIMenu()
        static var settingButton = UIBarButtonItem()
        static var logoutView = UIView()
        static var logoutYESButton = UIButton()
        static var logoutNOButton = UIButton()
        static var logoutText = UILabel()
        static var window = UIWindow()
        
        
 
   }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKey))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
                                         
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    
    func setupMenu(_ settings : String, _ about : String, _ contact : String, _ howItWorks : String, _ shareWith : String, _ logout : String, _ yesButton : String, _ noButton : String, _ logoutLbl : String, _ userLanguage : String, _ plate : String, screen : String){
        
        Messaging.messaging().token {token, error in
            
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }else if let token = token{
                print ("FCM registration token: \(token)")
                defaultLanguage.mToken = token
                
              }
         
        }
        defaultLanguage.auxMenu = UIMenu(title: "", children: [
                                UIAction (title: settings, image: UIImage(systemName: "gearshape.fill")) {
                                    action in
                                    
                                    
                                    
                                    let settings = self.storyboard?.instantiateViewController(identifier: "settingView") as! settings
                                           
                                    self.navigationController?.pushViewController(settings, animated: true)
                                    settings.userLanguageSelected=userLanguage.uppercased()
                                    settings.mToken = defaultLanguage.mToken
                                },
            
                            UIAction (title: about, image: UIImage(systemName: "info.circle.fill")) {
                                action in
                                let about = self.storyboard?.instantiateViewController(identifier: "aboutView") as! About
                                       
                                self.navigationController?.pushViewController(about, animated: true)
                                about.userLanguageSelected=userLanguage.uppercased()
                                
            },
        
            UIAction (title: contact, image: UIImage(systemName: "person.fill.questionmark.rtl")) {
                action in
                let contact = self.storyboard?.instantiateViewController(identifier: "contactView") as! contactView
                       
                self.navigationController?.pushViewController(contact, animated: true)
                contact.userLanguageSelected=userLanguage.uppercased()
                contact.screen = screen
                contact.plateName = plate
                
},
            UIAction (title: howItWorks, image: UIImage(systemName: "gearshape.2.fill")) {
                action in
                let howItWorks = self.storyboard?.instantiateViewController(identifier: "howitworksView") as! howItWorks
                       
                self.navigationController?.pushViewController(howItWorks, animated: true)
                howItWorks.userLanguageSelected=userLanguage.uppercased()
            },
            UIAction (title: shareWith, image: UIImage(named: "shared")) {
                action in
            },
            UIAction (title: logout, image: UIImage(named: "logout")) {
                action in

                self.logoutFunc(yesButton, noButton, logoutLbl, logout)
            },
            
            
        ])
        
        defaultLanguage.settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), menu: defaultLanguage.auxMenu)
        navigationItem.rightBarButtonItem = defaultLanguage.settingButton
    }
    
    func logoutFunc(_ yesButton : String, _ noButton : String, _ logoutLbl : String, _ logoutTitle : String) {
        
        let alert:UIAlertController
        
        alert = UIAlertController(title: logoutTitle, message: logoutLbl, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: yesButton, style: UIAlertAction.Style.default) {_ in
            self.getToken()
        })
          
        alert.addAction(UIAlertAction(title: noButton, style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true)
    }
    func getToken() {
        Messaging.messaging().token {token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }else if let token = token{
                print ("FCM registration token: \(token)")
                defaultLanguage.mToken = token
              }
        self.getLanguageUser(defaultLanguage.mToken)
        }
    }
    
    func getLanguageUser(_ mToken : String){
        var userLang : String = ""
        let token = mToken
        var userRef = DatabaseReference()
        userRef = Database.database().reference()
        let userRefQuery = userRef.child("Users").child("userLanguage")
        let query = userRefQuery.queryOrdered(byChild: "users").queryEqual(toValue: token)
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let language = snap.value as! [String : Any]
                    userLang = language["language"] as? String ?? ""
                }
                defaultLanguage.userLanguage = userLang
                
            }else{
                defaultLanguage.userLanguage = Locale.current.languageCode!
                
            }
            
            self.setUserNoActive(token, defaultLanguage.userLanguage)
        
        })
    }
    
    func setUserNoActive(_ mToken : String, _ language : String){
        var userRef = DatabaseReference()
        userRef = Database.database().reference()
        let token = mToken
        var key = ""
        let userRefQuery = userRef.child("activeSession").child(token)
        let query = userRefQuery.queryOrdered(byChild: "active").queryEqual(toValue: "ON")
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if (snapshot.exists()) {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    key = snap.key
                 }
                userRef.child("activeSession").child(token).child(key).updateChildValues(["active": "OFF"])
                
                
            }
            let mainControl = self.storyboard?.instantiateViewController(identifier: "Login") as! ViewController
            self.navigationController?.pushViewController(mainControl, animated: true)
            
            mainControl.userDefaultLanguage = language.uppercased()
            mainControl.mToken = token
         })
    }
   
}




