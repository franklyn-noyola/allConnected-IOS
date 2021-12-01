//
//  profileViewControler.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 13/4/21.
//

import UIKit
import Firebase
import SwiftUI

class profileViewControler: UIViewController, UISearchBarDelegate {

   
    @IBOutlet weak var searchButton: UIButton!
    var languages = languageTranslation().hindiLanguage
    @IBOutlet weak var sendNoti: UIButton!
    
    @IBOutlet weak var plateField: UILabel!
    var plateName : String = ""
    var mToken : String!
    var gotChat : String!
    var userLanguageSelected : String!
    var profileName : String!
    var emailName : String!
    var userSelf : String!
    var home : String!
    var noDataAvailable : String!
    var yesButtonLbl : String!
    var noButtonLbl : String!
    var logoutText : String!
    var settings : String!
    var howItWorks : String!
    var about : String!
    var contact : String!
    var logout : String!
    var searchUserText : String!
    var userRef : DatabaseReference!
    var sendNotiLbl : String!
    var closeLbl : String!
    var noExists : String!
    var userInfor : String!
    var typeVehicle : String!
    var brandHint : String!
    var modelHint : String!
    var colorHint : String!
    var yearHint : String!
    var shareWith : String!

    
    @IBOutlet weak var infoUser: UILabel!
    

    @IBOutlet weak var plateFieldName: UILabel!
    
    
    @IBOutlet weak var typeField: UILabel!
    @IBOutlet weak var brandField: UILabel!
    
    @IBOutlet weak var colorField: UILabel!
    
    @IBOutlet weak var yearField: UILabel!
    @IBOutlet weak var modelField: UILabel!
    
    @IBOutlet weak var typeData: UILabel!
    
    @IBOutlet weak var brandData: UILabel!
    
    @IBOutlet weak var modelData: UILabel!
    
    @IBOutlet weak var colorData: UILabel!
    
    @IBOutlet weak var yearData: UILabel!
    @IBOutlet weak var searchUser: UISearchBar!
    
    @IBOutlet weak var gotoChat: UIButton!
    
    @IBOutlet weak var sendNotification: UIButton!
       
    @IBOutlet weak var close: UIButton!
    
    @IBOutlet weak var userInfo: UIView!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchUser.text!.uppercased() == plateName) {
            showToast(message: userSelf, font: .systemFont(ofSize: 9.0))
            return
        }
        let userQuery = userRef.child("Users")
        let getSearch = userQuery.queryOrdered(byChild: "plate_user").queryEqual(toValue: searchUser.text!.uppercased())
        getSearch.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                self.plateFieldName.text = self.searchUser.text!.uppercased()
                self.userInfo.isHidden = false
                self.searchUser.isHidden = true
                self.searchButton.isHidden = true
                self.getUserInfo()
                self.view.endEditing(true)
            }else{
                self.showToast(message: self.noExists, font: .systemFont(ofSize: 14.0))
            }
        })
       
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if (searchUser.text!.uppercased() == plateName) {
            showToast(message: userSelf, font: .systemFont(ofSize: 9.0))
            return
        }
        let userQuery = userRef.child("Users")
        let getSearch = userQuery.queryOrdered(byChild: "plate_user").queryEqual(toValue: searchUser.text!.uppercased())
        getSearch.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                self.plateFieldName.text = self.searchUser.text!.uppercased()
                self.userInfo.isHidden = false
                self.searchUser.isHidden = true
                self.searchButton.isHidden = true
                self.getUserInfo()
                self.view.endEditing(true)
            }else{
                self.showToast(message: self.noExists, font: .systemFont(ofSize: 14.0))
            }
        })
    }
    
    private func getUserInfo(){
        let getCarData = userRef.child("Users")
        let getCarUserData = getCarData.queryOrdered(byChild: "plate_user").queryEqual(toValue: searchUser.text!)
        getCarUserData.observeSingleEvent(of: .value, with: {(snapshot) in
            var dat1 : String=""
            var dat2 : String=""
            var dat3 : String=""
            var dat4 : String=""
            var dat5 : String=""
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let carData = snap.value as! [String : Any]
                dat1 = carData["cartype"] as? String ?? ""
                dat2 = carData["carbrand"] as? String ?? ""
                dat3 = carData["carmodel"] as? String ?? ""
                dat4  = carData["carcolor"] as? String ?? ""
                dat5 = carData["year"] as? String ?? ""
                
                print (dat1)
                
            }
            self.setSearchData(dat1, dat2, dat3, dat4, dat5)
       
            
        })
        
    }
    
    func setSearchData(_ type : String, _ brand : String, _ model : String, _ color : String, _ year : String){
        if (type=="") {
            typeData.text = noDataAvailable
        }else{
            typeData.text = type.uppercased()
        }
        if (brand=="") {
            brandData.text = noDataAvailable
        }else {
            brandData.text = brand.uppercased()
        }
        if (model==""){
            modelData.text = noDataAvailable
        }else {
            modelData.text = model.uppercased()
        }
        if (color==""){
            colorData.text = noDataAvailable
        }else {
            colorData.text = color.uppercased()
        }
        if (year == "") {
            yearData.text = noDataAvailable
        }else {
            yearData.text = year.uppercased()
        }
    }
    
    var backgroundView: UIImageView = {
        let backgroundView = UIImageView (frame: UIScreen.main.bounds)
        backgroundView.contentMode = .scaleAspectFit
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        backgroundView.image = UIImage(named: "background")
        return backgroundView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        self.searchUser.delegate = self
       let tabController = self.storyboard?.instantiateViewController(identifier: "contactView") as! contactView
        tabController.plateName = plateName
        userRef = Database.database().reference()
        getNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(disableBtn), name: NSNotification.Name(rawValue: "Disable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableBtn), name: NSNotification.Name(rawValue: "Enable"), object: nil)
        userInfo.isHidden = true
        changeLanguage()
        configUserFields()
        searchButton.setTitle(searchUserText, for: UIControl.State.normal)
        searchButton.layer.cornerRadius = 8
                
        self.view.insertSubview(backgroundView, at: 10)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        //self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        plateField.text = plateName
        setupMenu(settings, about, contact, howItWorks, shareWith, logout, yesButtonLbl, noButtonLbl, logoutText, userLanguageSelected, plateName, screen: "0")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func disableBtn(){
        searchUser.isUserInteractionEnabled = false
        searchButton.isEnabled = false
    }
    
    @objc func enableBtn(){
        searchUser.isUserInteractionEnabled = true
        searchButton.isEnabled = true
    }
    
    @IBAction func closeAction(_ sender: Any) {
        searchUser.isHidden = false
        searchButton.isHidden = false
        userInfo.isHidden = true
        searchUser.text = ""
    }
    
    
    
    func configUserFields(){
        infoUser.text = userInfor
        brandField.text = brandHint+":"
        modelField.text = modelHint+":"
        colorField.text = colorHint+":"
        yearField.text = yearHint+":"
        typeField.text = typeVehicle
        gotoChat.setTitle(gotChat, for: UIControl.State.normal)
        gotoChat.layer.cornerRadius = 8
        sendNotification.layer.cornerRadius = 8
        close.layer.cornerRadius = 8
        sendNotification.setTitle(sendNotiLbl, for: UIControl.State.normal)
        close.setTitle(closeLbl, for: UIControl.State.normal)
        
    }
    
    func getNotifications() {
        let getNotification = userRef.child("sendMessages").child(plateName)
        getNotification.observe(.value, with:  {(snapshot) in
            var countRead = 0;
            var getRead : String!
            if (snapshot.exists()) {
                for child in snapshot.children {
                    let dataChild = child as! DataSnapshot
                    let data = dataChild.value as! [String : Any]
                    getRead = data["leido"] as? String ?? ""
                    if (getRead == "No") {
                        countRead = countRead + 1
                    }
                }
                if (countRead >= 1) {
                    self.tabBarController?.tabBar.items?[3].image = UIImage(systemName: "envelope.badge.fill")
                }

                if (countRead == 0) {
                    self.tabBarController?.tabBar.items?[3].image = UIImage(systemName: "envelope.fill")
                }
            }
        })
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        .darkContent
    }
    
    
    @IBAction func goChatAction(_ sender: Any) {
        let goChat = storyboard?.instantiateViewController(identifier: "chatView") as! chatViewSection
               
        navigationController?.pushViewController(goChat, animated: true)
       
        goChat.userLanguageSelected=userLanguageSelected.uppercased()
        goChat.userToChat=searchUser.text!.uppercased()
        goChat.screenFrom = "1"
        goChat.plateNumber=plateName
        
    }
    
    
    
    @IBAction func sendNotiAction(_ sender: Any) {
        let goSendNotification = storyboard?.instantiateViewController(identifier: "sendNotification") as! sendNotification
        
        goSendNotification.userLanguageSelected = self.userLanguageSelected.uppercased()
        goSendNotification.plateName = plateName
        goSendNotification.userTarget = searchUser.text!.uppercased()
        goSendNotification.fromScreen = "0"
        self.navigationController?.pushViewController(goSendNotification, animated: true)
    }
    
    func changeLanguage(){
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
        home = languages["home_menu"]!
        settings = languages["action_settings"]!
        about = languages["action_about"]!
        contact = languages["action_contacts"]!
        howItWorks = languages["action_howItWorks"]!
        logout = languages["logout_menu"]!
        searchUserText = languages["searchUser"]!
        userSelf = languages["userSelf"]!
        noExists = languages["noExists"]!
        userInfor = languages["userInfo"]!
        typeVehicle = languages["typeVehicle"]!
        brandHint = languages["brandHint"]!
        modelHint = languages["modelHint"]!
        colorHint = languages["colorHint"]!
        yearHint = languages["yearHint"]!
        gotChat = languages["gotChat"]!
        sendNotiLbl  = languages["sendNoti"]!
        closeLbl = languages["closeButton"]!
        yesButtonLbl = languages["yes"]!
        noButtonLbl = languages["No"]!
        logoutText = languages["logout"]!
        shareWith = languages["shareWith"]!
        noDataAvailable = languages["noData"]!
        self.navigationItem.title = home
    
    }


    }
    


