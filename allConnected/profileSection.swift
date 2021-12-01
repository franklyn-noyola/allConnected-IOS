//
//  profileSection.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 25/4/21.
//

import UIKit
import Firebase

class profileSection: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var plateName : String!
    var nameProfile : String!
    var email : String!
    var yesButtonLbl : String!
    var noButtonLbl : String!
    var logoutText : String!
    var userRef : DatabaseReference!
    var infoUpdated : String!
    var userLanguageSelected : String!
    var languages = languageTranslation().englishLanguage
    var wrong_password : String!
    var selVehiculos =  languageTranslation().selectVehicleEN
    var selVehicleType = [String]()
    var additional : String!
    var brandNew : String!
    var typeNew : String!
    var modelNew : String!
    var colorNew : String!
    var yearNew : String!
    var profileTitle : String!
    var updateButtonText : String!
    var changePassText : String!
    var cancelButtonText : String!
    var modifyButtonText : String!
    var updateInfoText : String!
    var brandData : String!
    var modelData : String!
    var colorData : String!
    var yearData : String!
    var typeData : String!
    var selectVehicle : String!
    var selectedItem : String!
    var homeMenu : String!
    var passStrong : String!
    var showPass : Bool = false
    var noPassMatch : String!
    var contact : String!
    var settings : String!
    var howitworks : String!
    var about : String!
    var logout : String!
    var changedPassword : String!
    var passStrongErr : String!
    var shareWith : String!
    
    @IBOutlet weak var newPassButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var confirmPassButton: UIButton!
    @IBOutlet weak var strongPass: UILabel!
    @IBOutlet weak var PlateNumber: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var updatePassButton: UIButton!
    
    @IBOutlet weak var additionalInfo: UILabel!
    @IBOutlet weak var selectTypeList: UITableView!
    @IBOutlet weak var selectTypeField: UIButton!
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var colorField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    
    @IBOutlet weak var confirmPassLabel: UITextField!
    @IBOutlet weak var newPassLabel: UITextField!
    @IBOutlet weak var updatePassLbl: UILabel!
    @IBOutlet weak var cancelButtonLbl: UIButton!
    @IBOutlet weak var modifyInfo: UIButton!
    
    @IBOutlet weak var updatePassPop: UIView!
    
    @IBOutlet weak var updatePassLabel: UIButton!
    @IBOutlet weak var cancelPassbuttonLbl: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage()
        self.hideKeyboardWhenTappedAround()
    
        NotificationCenter.default.addObserver(self, selector: #selector(disableBtn), name: NSNotification.Name(rawValue: "Disable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableBtn), name: NSNotification.Name(rawValue: "Enable"), object: nil)
     
       
        updatePassPop.isHidden = true
        userRef = Database.database().reference()
        getUserData()
        setupMenu(settings, about, contact, howitworks, shareWith, logout, yesButtonLbl, noButtonLbl, logoutText, userLanguageSelected, plateName, screen: "1")
    }
    
    @objc func disableBtn(){
        updatePassButton.isEnabled = false
        modifyInfo.isEnabled = false
    }
    
    @objc func enableBtn(){
        updatePassButton.isEnabled = true
        modifyInfo.isEnabled = true
    }
    
    
    @IBAction func showNewPassAction(_ sender: Any) {
        if (showPass == false){
            newPassLabel.isSecureTextEntry = true
            showPass = true
        newPassButton.setImage(UIImage(systemName: "eye"), for: UIControl.State.normal)
            
        return
        }
        if (showPass == true){
            newPassLabel.isSecureTextEntry = false
            showPass = false
        
            newPassButton.setImage(UIImage(systemName: "eye.slash"), for: UIControl.State.normal)
            
        return
        }
    }
    
    @IBAction func showConfirmPassAction(_ sender: Any) {
        if (showPass == false){
            confirmPassLabel.isSecureTextEntry = true
            showPass = true
        
            confirmPassButton.setImage(UIImage(systemName: "eye"), for: UIControl.State.normal)
            
        return
        }
        if (showPass == true){
            confirmPassLabel.isSecureTextEntry = false
            showPass = false
        
            confirmPassButton.setImage(UIImage(systemName: "eye.slash"), for: UIControl.State.normal)
            
        return
        }
    }
    
    
    @IBAction func cancelPassAction(_ sender: Any) {
        selectTypeList.isHidden=true
        cancelButtonLbl.isHidden=true
        brandField.isEnabled = false
        modelField.isEnabled = false
        colorField.isEnabled = false
        yearField.isEnabled = false
        selectTypeField.isEnabled = false
        updatePassPop.isHidden = true
        modifyInfo.isEnabled=true
    }
    
    @IBAction func updatePassAction(_ sender: Any) {
        modifyInfo.isEnabled=false
        getUpdatePass()
    
    }
    
    @IBAction func updateAction(_ sender: Any) {
        if (newPassLabel.text == "" || confirmPassLabel.text == ""){
            showToast(message: wrong_password, font: .systemFont(ofSize: 10.0))
            return
        }
        
        if (newPassLabel.text != confirmPassLabel.text){
            showToast(message: noPassMatch, font: .systemFont(ofSize: 14.0))
            return
        }
        if (!isStrongPass(newPassLabel.text!)){
            showToast(message: wrong_password, font: .systemFont(ofSize: 10.0))
            return
        }
        var key : String = ""
        let passQuery = userRef.child("Users")
        let getPass = passQuery.queryOrdered(byChild: "plate_user").queryEqual(toValue: plateName)
        getPass.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                key = snap.key
            }
            self.userRef.child("Users").child(key).updateChildValues(["user_password": self.newPassLabel.text!])
        })
        showToast(message: changedPassword, font: .systemFont(ofSize: 14.0))
        selectTypeList.isHidden=true
        cancelButtonLbl.isHidden=true
        brandField.isEnabled = false
        modelField.isEnabled = false
        colorField.isEnabled = false
        yearField.isEnabled = false
        selectTypeField.isEnabled = false
        updatePassPop.isHidden = true
        modifyInfo.isEnabled=true
    }
    
    private func getUpdatePass(){
        view.addSubview(updatePassPop)
        updatePassPop.isHidden = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    private func getUserData(){
        let getUserData = userRef.child("Users")
        let userQuery = getUserData.queryOrdered(byChild: "plate_user").queryEqual(toValue: plateName)
        userQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let data = snap.value as! [String : Any]
                self.nameProfile = data["user_name"] as? String ?? ""
                self.email = data["user_email"] as? String ?? ""
                self.brandData = data["carbrand"] as? String ?? ""
                self.colorData = data["carcolor"] as? String ?? ""
                self.modelData = data["carmodel"] as? String ?? ""
                self.typeData = data["cartype"] as? String ?? ""
                self.yearData = data["year"] as? String ?? ""
            }
            self.configFields()
            
        })
    }
    
    func configFields(){
        updatePassPop.layer.borderWidth=2
        updatePassPop.layer.cornerRadius = 8
        selectTypeList.isHidden=true
        cancelButtonLbl.isHidden=true
        brandField.isEnabled = false
        modelField.isEnabled = false
        colorField.isEnabled = false
        yearField.isEnabled = false
        selectTypeField.isEnabled = false
        profileName.text = nameProfile
        PlateNumber.text = plateName
        additionalInfo.text = additional
        emailField.text = email
        updatePassButton.setTitle(changePassText, for: UIControl.State.normal)
        updatePassButton.layer.cornerRadius = 8
       if (brandData == ""){
            brandField.attributedPlaceholder = NSAttributedString(string: brandNew, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white])
        }else{
            brandField.text = brandData
        }
        if (modelData == ""){
            modelField.attributedPlaceholder = NSAttributedString(string: modelNew, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white])
        }else{
            modelField.text = modelData
        }
        if (colorData == ""){
            colorField.attributedPlaceholder = NSAttributedString(string: colorNew, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white])
        }else{
            colorField.text = colorData
        }
        if (yearData == ""){
            yearField.attributedPlaceholder = NSAttributedString(string: yearNew, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white])
        }else{
            yearField.text = yearData
        }
        if (typeData == ""){
            selectTypeField.setTitle(selectVehicle, for: UIControl.State.normal)
        }else{
            selectTypeField.setTitle(typeData, for: UIControl.State.normal)
        }
        cancelPassbuttonLbl.setTitle(cancelButtonText, for: UIControl.State.normal)
        cancelPassbuttonLbl.layer.cornerRadius = 8
        updatePassLabel.setTitle(updateButtonText, for: UIControl.State.normal)
        updatePassLabel.layer.cornerRadius = 8
        cancelButtonLbl.setTitle(cancelButtonText, for: UIControl.State.normal)
        cancelButtonLbl.layer.cornerRadius = 8
        modifyInfo.setTitle(modifyButtonText, for: UIControl.State.normal)
        modifyInfo.layer.cornerRadius = 8
        updatePassLbl.text = changePassText
        strongPass.text = passStrong
    }
  
    
    @IBAction func selectTypeAction(_ sender: Any) {
        if (selectTypeList.isHidden == true){
            changeLanguage()
            
            selectTypeList.isHidden = false
            
        }else{
            changeLanguage()
            selectTypeList.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selVehicleType.count
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = UITableViewCell (style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cel.textLabel?.text = selVehicleType[indexPath.row]
        return cel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                    IndexPath){
        
        selectedItem = selVehicleType[indexPath.row]
        
        selectTypeList?.isHidden=true
        selectTypeField.setTitle(selectedItem, for: UIControl.State.normal)
    }
    
    

    @IBAction func cancelButtonAction(_ sender: Any) {
        selectTypeList.isHidden=true
        cancelButtonLbl.isHidden=true
        brandField.isEnabled = false
        modelField.isEnabled = false
        colorField.isEnabled = false
        yearField.isEnabled = false
        selectTypeField.isEnabled = false
        updatePassButton.isEnabled = true
        modifyInfo.setTitle(modifyButtonText, for: UIControl.State.normal)
        if (brandData == ""){
            brandField.placeholder = brandNew
        }else{
            brandField.text = brandData
        }
        if (modelData == ""){
            modelField.placeholder = modelNew
        }else{
            modelField.text = modelData
        }
        if (colorData == ""){
            colorField.placeholder = colorNew
        }else{
            colorField.text = colorData
        }
        if (yearData == ""){
            yearField.placeholder = yearNew
        }else{
            yearField.text = yearData
        }
        if (typeData == ""){
            selectTypeField.setTitle(selectVehicle, for: UIControl.State.normal)
        }else{
            selectTypeField.setTitle(typeData, for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func modifyInfoAction(_ sender: Any) {
        if (modifyInfo.currentTitle == modifyButtonText){
            
            cancelButtonLbl.isHidden=false
            brandField.isEnabled = true
            modelField.isEnabled = true
            colorField.isEnabled = true
            yearField.isEnabled = true
            selectTypeField.isEnabled = true
            updatePassButton.isEnabled = false
            modifyInfo.setTitle(updateInfoText, for: UIControl.State.normal)
            return
        }
        if (modifyInfo.currentTitle == updateInfoText){
            setUserUpdate()
            showToast(message: infoUpdated, font: .systemFont(ofSize: 12.0))
            selectTypeList.isHidden=true
            cancelButtonLbl.isHidden=true
            brandField.isEnabled = false
            modelField.isEnabled = false
            colorField.isEnabled = false
            yearField.isEnabled = false
            selectTypeField.isEnabled = false
            updatePassButton.isEnabled = false
            modifyInfo.setTitle(modifyButtonText, for: UIControl.State.normal)
            return
        }
    }
    
    private func setUserUpdate() {
        var key : String = ""
        let updateUser = userRef.child("Users")
        let userUpdate = updateUser.queryOrdered(byChild: "plate_user").queryEqual(toValue: plateName)
        userUpdate.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                key = snap.key
            }
            self.userRef.child("Users").child(key).updateChildValues(["cartype": self.selectedItem,
                "carbrand" : self.brandField.text!,
                "carmodel" : self.modelField.text!,
                "carcolor" : self.colorField.text!,
                "year" : self.yearField.text!])
        })
    }
     
    
    func changeLanguage(){
        if (userLanguageSelected == "ES"){
            languages = languageTranslation().spanishLanguage
            selVehiculos = languageTranslation().selectVehicleSP
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
          
        }
        if (userLanguageSelected == "EN"){
            languages = languageTranslation().englishLanguage
            selVehiculos = languageTranslation().selectVehicleEN
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "FR"){
            languages = languageTranslation().frenchLanguage
            selVehiculos = languageTranslation().selectVehicleFR
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold) ]
        }
        if (userLanguageSelected == "DE"){
            languages = languageTranslation().germanLanguage
            selVehiculos = languageTranslation().selectVehicleDE
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "IT"){
            languages = languageTranslation().italianLanguage
            selVehiculos = languageTranslation().selectVehicleIT
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "PT"){
            languages = languageTranslation().portugueseLanguage
            selVehiculos = languageTranslation().selectVehiclePT
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "RU"){
            selVehiculos = languageTranslation().selectVehicleRU
            languages = languageTranslation().russianLanguage
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "ZH"){
            selVehiculos = languageTranslation().selectVehicleZH
            languages = languageTranslation().chineseLanguage
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "JA"){
            languages = languageTranslation().japaneseLanguage
            selVehiculos = languageTranslation().selectVehicleJA
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "NL"){
            languages = languageTranslation().dutchLanguage
            selVehiculos = languageTranslation().selectVehicleNL
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "PL"){
            languages = languageTranslation().polishLanguage
            selVehiculos = languageTranslation().selectVehiclePL
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "KO"){
            languages = languageTranslation().koreanLanguage
            selVehiculos = languageTranslation().selectVehicleKO
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "SV"){
            languages = languageTranslation().swedishLanguage
            selVehiculos = languageTranslation().selectVehicleSV
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "AR"){
            languages = languageTranslation().arabicLanguage
            selVehiculos = languageTranslation().selectVehicleAR
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "UR"){
            languages = languageTranslation().urduLanguage
            selVehiculos = languageTranslation().selectVehicleUR
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "HI"){
            languages = languageTranslation().hindiLanguage
            selVehiculos = languageTranslation().selectVehicleHI
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: UIFont.Weight.bold) ]
        }
        
        additional = languages["additionalInfor"]!
        changePassText = languages["changePassHint"]!
        brandNew = languages["brandHint"]!
        colorNew = languages["colorHint"]!
        modelNew = languages["modelHint"]!
        yearNew = languages["yearHint"]!
        profileTitle = languages["profile_menu"]!
        modifyButtonText = languages["modifyInfo"]!
        updateInfoText = languages["updateInfo"]!
        cancelButtonText = languages["cancel"]!
        updateButtonText = languages["updatePassHint"]!
        selectVehicle = languages["selectVehicle"]!
        homeMenu = languages["home_menu"]!
        passStrong = languages["password_strong"]!
        selVehicleType = selVehiculos
        noPassMatch = languages["noPassMatch"]!
        wrong_password = languages["wrong_password"]!
        settings = languages["action_settings"]!
        about = languages["action_about"]!
        contact = languages["action_contacts"]!
        howitworks = languages["action_howItWorks"]!
        logout = languages["logout_menu"]!
        changedPassword = languages["changedPassword"]!
        passStrongErr = languages["passStrongErr"]!
        infoUpdated = languages["infoUpdated"]!
        yesButtonLbl = languages["yes"]!
        noButtonLbl = languages["No"]!
        logoutText = languages["logout"]!
        shareWith = languages["shareWith"]!
        self.navigationItem.title = profileTitle
        
    }
    
}
