//
//  ViewController.swift
//  allConnected2
//
//  Created by Franklyn Garcia Noyola on 10/4/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var loginProgress: UIActivityIndicatorView!
    var plateNumberText : String!
    var passwordText : String!
    var welcomeText : String!
    var mToken : String!
    var wrong_password: String!
    var changedPassword : String!
    var cancelText : String!
    var strongPassLbl : String!
    var changePssButton : String!
    var passChangeLbl : String!
    var noPassMatch : String!
    var forgottenText : String!
    var newUserText : String!
    var profileTab : String!
    var chatTab : String!
    var userRef : DatabaseReference!
    var notificationsTab : String!
    var newPassHint  : String!
    var confirmPassHint  : String!
    var strongPass : String!

    
    @IBOutlet weak var plateNumber: UITextField!
    
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var iconLogo: UIImageView!
    
    @IBOutlet weak var changePassText: UILabel!
    
    @IBOutlet weak var changePassButton: UIButton!
    @IBOutlet weak var cancelPassButton: UIButton!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var changepassField: UITextField!
    
    @IBOutlet weak var forgottenPass: UIButton!
    

    @IBOutlet weak var newUserLabel: UIButton!
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    
    @IBOutlet weak var showPassChange: UIButton!
    
    @IBOutlet weak var strongPassText: UILabel!
    
    @IBOutlet weak var showPassConfirm: UIButton!
    var plateNumberField : String!
    var passwordField : String!
    var wrongUser : String!
    var showPass : Bool = false
    var userDefaultLanguage : String!
    var buttonLbl : String!
    
    @IBAction func showPassChangAction(_ sender: Any) {
        if (changepassField.isSecureTextEntry == false){
            changepassField.isSecureTextEntry = true
            showPassChange.setImage(UIImage(systemName: "eye"), for: UIControl.State.normal)
        return
        }
        if (changepassField.isSecureTextEntry == true) {
            changepassField.isSecureTextEntry = false
            showPassChange.setImage(UIImage(systemName: "eye.slash"), for: UIControl.State.normal)
        return
        }
    }
    
    @IBAction func showPassConfirmChange(_ sender: Any) {
        if (confirmPassField.isSecureTextEntry == false){
            confirmPassField.isSecureTextEntry = true
            showPassConfirm.setImage(UIImage(systemName: "eye"), for: UIControl.State.normal)
        return
        }
        if (confirmPassField.isSecureTextEntry == true) {
            confirmPassField.isSecureTextEntry = false
            showPassConfirm.setImage(UIImage(systemName: "eye.slash"), for: UIControl.State.normal)
        return
        }
    }
    @IBAction func cancelPassAction(_ sender: Any) {
        buttonLogin.isEnabled = true
        newUserLabel.isEnabled = true
        changePassView.isHidden = true
    }
    
    
    @IBOutlet weak var changePassView: UIView!
    
    @IBAction func changePassAction(_ sender: Any) {
        var key : String!
        
        if (changepassField.text == "" || confirmPassField.text == ""){
            self.showToast(message: wrong_password, font: .systemFont(ofSize: 12.0))
            return
        }
        
        if (changepassField.text != confirmPassField.text){
            showToast(message: noPassMatch, font: .systemFont(ofSize: 14.0))
            return
        }
        
        if (!isStrongPass(changepassField.text!)){
            showToast(message: strongPassLbl, font: .systemFont(ofSize: 12.0))
            return
        }
        let passQuery = userRef.child("Users")
        let getPass = passQuery.queryOrdered(byChild: "plate_user").queryEqual(toValue: plateNumberField.uppercased())
        getPass.observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                key = snap.key
            }
            self.userRef.child("Users").child(key).updateChildValues(["user_password": self.changepassField.text!,
                                                                  "resetPass": "0"])
        })
        showToast(message: changedPassword, font: .systemFont(ofSize: 14.0))
        buttonLogin.isEnabled = true
        newUserLabel.isEnabled = true
        changePassView.isHidden = true
        plateNumber.text = ""
        password.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = true
        self.hideKeyboardWhenTappedAround()
        loginProgress.isHidden = true
        userRef = Database.database().reference()
        changeLanguage()
        configureFields()
       
    }
   
    
    @IBAction func loginButton(_ sender: UIButton) {
       
        plateNumberField = plateNumber.text!
        passwordField = password.text!
        
       
        if (plateNumberField.isEmpty || passwordField.isEmpty){
            self.showToast(message: wrongUser, font: .systemFont(ofSize: 14.0))
            return
        }
        let userRefQuery = userRef.child("Users")
        let activatedQuery = userRefQuery.queryOrdered(byChild: "plate_user").queryEqual(toValue: plateNumberField.uppercased())
        activatedQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            var passWord : String!
            if (snapshot.exists()){
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let user = snap.value as! [String : Any]
                    passWord = user["user_password"] as? String ?? ""
                }
                if (passWord != self.passwordField){
                    self.showToast(message: self.wrongUser, font: .systemFont(ofSize: 14.0))
                    return
                }else{
                    self.loginProgress.isHidden = false
                    self.loginProgress.startAnimating()
                    self.getUserActivated()
                }
            }else{
                self.showToast(message: self.wrongUser, font: .systemFont(ofSize: 14.0))
                return
            }
            
            
        })
    }
    
    private func getUserActivated() {
        let userActivated = userRef.child("Users").child("ActivatedUser")
        let activatedQuery = userActivated.queryOrdered(byChild: "userActivated").queryEqual(toValue: plateNumberField.uppercased())
        activatedQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            var activatedOption : String!
            if (snapshot.exists()){
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let activated = snap.value as! [String : Any]
                    activatedOption = activated["activated"] as? String ?? ""
                }
                if (activatedOption=="ON"){
                    self.getResetPass()
                }else{
                    self.activatedErrMsg()
                }
            }else{
                self.activatedErrMsg()
            }
            
            
        } )
    }
    
    private func getResetPass(){
        let resetPass = userRef.child("Users")
        let getPass = resetPass.queryOrdered(byChild: "plate_user").queryEqual(toValue: plateNumberField.uppercased())
        getPass.observeSingleEvent(of: .value, with: {(snapshot) in
            var passReset : String!
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let reset = snap.value as! [String : Any]
                passReset = reset["resetPass"] as? String ?? ""
            }
            if (passReset == "0") {
                self.setActiveUser()
            }else{
                self.changePassView.isHidden = false
                self.buttonLogin.isEnabled = false
                self.newUserLabel.isEnabled = false
            }
        })
    }
        
    private func setActiveUser(){
        let userActivated = userRef.child("activeSession").child(mToken)
        userActivated.observeSingleEvent(of: .value, with: {(snapshot) in
            var active : String!
            if (snapshot.exists()){
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let activated = snap.value as! [String : Any]
                    active = activated["active"] as? String ?? ""
                }
                if (active=="ON"){
                    self.getTabBar()
                }else{
                    let setactiveON = self.userRef.child("activeSession").child(self.mToken)
                    let activeOn = setactiveON.queryOrdered(byChild: "active").queryEqual(toValue: "OFF")
                    activeOn.observeSingleEvent(of: .value, with: {(snapshot) in
                        var key : String!
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            key = snap.key
                        }
                        self.userRef.child("activeSession").child(self.mToken).child(key).updateChildValues(["active": "ON", "activeUser" : self.plateNumberField.uppercased()])
                        
                    })
                }
                self.pushCreate(self.mToken, self.plateNumberField.uppercased())
            }else{
                self.userRef.child("activeSession").child(self.mToken).childByAutoId().setValue(["active" : "ON", "activeUser" : self.plateNumberField.uppercased()])
                self.pushCreate(self.mToken, self.plateNumberField.uppercased())
            }
            
        } )
    }
    
    private func pushCreate(_ mToken : String, _ plateUser : String) {
        let pushCreate = userRef.child("pushNotification").child(plateUser)
        pushCreate.observeSingleEvent(of: .value, with: {(snapshot) in
            if (!snapshot.exists()) {
                self.userRef.child("pushNotification").child(plateUser).childByAutoId().setValue(["active": "ON",
                                                "tockenUser": mToken])
            }
            self.getTabBar()
        })
    }
    
    private func activatedErrMsg() {
        if (userDefaultLanguage=="ES"){
            showToast(message: "El usuario/matrícula " + plateNumberField.uppercased() + " no está registrado, por favor revise su correo electrónico (Bandeja de entrada o SPAM) para activarlo.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="EN"){
            showToast(message: "User/Plate number " + plateNumberField.uppercased() + " is not registered, please check your email (Inbox or SPAM) to activate it.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="FR"){
            showToast(message: "Utilisateur / Numéro de plaque " + plateNumberField.uppercased() + " n'est pas enregistré, veuillez vérifier votre email (Boîte de réception ou SPAM) pour l'activer.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="DE"){
            showToast(message: "Benutzer/Kennzeichen " + plateNumberField.uppercased() + " ist nicht registriert. Bitte überprüfen Sie Ihre E-Mails (Posteingang oder SPAM), um sie zu aktivieren.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="IT"){
            showToast(message: "Utente/Numero di targa " + plateNumberField.uppercased() + " non è registrato, controlla la tua email (Posta in arrivo o SPAM) per attivarlo.", font: .systemFont(ofSize: 11.0))
            return
        }
        
        if (userDefaultLanguage=="PT"){
            showToast(message: "Usuário/Número da placa " + plateNumberField.uppercased() + " não está cadastrado, verifique seu e-mail (caixa de entrada ou SPAM) para ativá-lo.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="RU"){
            showToast(message: "Пользователь/номерной знак " + plateNumberField.uppercased() + " не зарегистрирован, пожалуйста, проверьте свою электронную почту (Входящие или СПАМ), чтобы активировать его.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="ZH"){
            showToast(message: "用户/板号" + plateNumberField.uppercased() + "尚未注册，请检查您的电子邮件（收件箱或垃圾邮件）以将其激活。", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userDefaultLanguage=="JA"){
            showToast(message: "ユーザー/プレート番号 " + plateNumberField.uppercased() + " が登録されていません。メール（受信トレイまたはスパム）を確認してアクティブにしてください。", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userDefaultLanguage=="NL"){
            showToast(message: "Gebruiker/Plaatnummer " + plateNumberField.uppercased() + " is niet geregistreerd. Controleer uw e-mail (Inbox of SPAM) om deze te activeren.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="PL"){
            showToast(message: "Użytkownik/Numer rejestracyjny " + plateNumberField.uppercased() + " nie jest zarejestrowany, sprawdź swój e-mail (skrzynkę odbiorczą lub spam), aby go aktywować.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="KO"){
            showToast(message: "사용자/플레이트 번호 " + plateNumberField.uppercased() + "가 등록되지 않았습니다. 활성화하려면 이메일 (받은 편지함 또는 SPAM)을 확인하십시오.", font: .systemFont(ofSize: 11.0))
            return
        }
        
        if (userDefaultLanguage=="SV"){
            showToast(message: "Användare/plattnummer " + plateNumberField.uppercased() + " är inte registrerad, kontrollera din e-post (inkorg eller SPAM) för att aktivera den.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="AR"){
            showToast(message: "المستخدم / رقم اللوحة " + plateNumberField.uppercased() + "غير مسجل ، يرجى التحقق من بريدك الإلكتروني (صندوق الوارد أو الرسائل الاقتحامية) لتفعيله", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userDefaultLanguage=="UR"){
            showToast(message: "صارف / پلیٹ نمبر " + plateNumberField.uppercased() + "رجسٹرڈ نہیں ہے ، براہ کرم اسے فعال کرنے کے لئے اپنا ای میل (ان باکس یا اسپیم) چیک کریں", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userDefaultLanguage=="HI"){
            showToast(message: "उपयोगकर्त/प्लेट नंबर " + plateNumberField.uppercased() + " पंजीकृत नहीं है, कृपया इसे सक्रिय करने के लिए अपने ईमेल (इनबॉक्स या स्पैम) की जांच करें।", font: .systemFont(ofSize: 14.0))
            return
        }
    }
    
    func getTabBar () {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeTab = storyboard.instantiateViewController(identifier: "homeTab") as UITabBarController
         let profileSBVC = homeTab.viewControllers?[0] as! UINavigationController
        let profileView = profileSBVC.topViewController as! profileViewControler
        let profileSectionV = homeTab.viewControllers?[1] as! UINavigationController
        let profileSection = profileSectionV.topViewController as! profileSection
        let chatSectionV = homeTab.viewControllers?[2] as! UINavigationController
        let chatSection = chatSectionV.topViewController as! chatController
        let notificationV = homeTab.viewControllers?[3] as! UINavigationController
        let notification = notificationV.topViewController as! notificationController
          chatSection.plateName = plateNumberField.uppercased()
            chatSection.tabBarItem.title = chatTab
          chatSection.userLanguageSelected = self.userDefaultLanguage.uppercased()
          chatSection.mToken = mToken
          notification.plateName = plateNumberField.uppercased()
          notification.userLanguageSelected=self.userDefaultLanguage.uppercased()
        notification.mToken = mToken
            notification.tabBarItem.title = notificationsTab
          profileView.plateName=plateNumberField.uppercased()
            profileView.userLanguageSelected=self.userDefaultLanguage.uppercased()
            profileSection.tabBarItem.title = profileTab
          homeTab.selectedIndex=0
          profileSection.plateName=plateNumberField.uppercased()
            profileSection.userLanguageSelected=self.userDefaultLanguage.uppercased()
          (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeTab)
        
    }
    
    
    @IBAction func showPassword(_ sender: Any) {
        if (showPass == false){
            password.isSecureTextEntry = true
            showPass = true
        
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: UIControl.State.normal)
            
        return
        
        }
       
        if (showPass == true){
            password.isSecureTextEntry = false
            showPass = false
        
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: UIControl.State.normal)
            
        return
        }
        
    }
    
  private func configureFields(){
        
        changePassView.isHidden = true
        changePassView.layer.borderWidth = 2
        changePassView.layer.cornerRadius = 8
        changePassText.text = passChangeLbl.uppercased()
        changepassField.layer.borderWidth = 1
        confirmPassField.layer.borderWidth = 1
        changepassField.attributedPlaceholder = NSAttributedString(string: newPassHint, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
        changePassButton.layer.cornerRadius = 8
        changepassField.layer.cornerRadius = 8
        confirmPassField.layer.cornerRadius = 8
        strongPassText.text = strongPass
        confirmPassField.attributedPlaceholder = NSAttributedString(string: confirmPassHint, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
        changePassButton.setTitle(changePssButton, for: UIControl.State.normal)
        cancelPassButton.setTitle(cancelText, for: UIControl.State.normal)
        cancelPassButton.layer.cornerRadius = 8
        buttonLogin.layer.cornerRadius = 8
          plateNumber.layer.borderWidth = 1
        password.layer.borderWidth = 1
        plateNumber.layer.cornerRadius = 8
        password.layer.cornerRadius = 8
    plateNumber.attributedPlaceholder = NSAttributedString(string: plateNumberText, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
    password.attributedPlaceholder = NSAttributedString(string: passwordText, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
    welcomeMessage.text = welcomeText
    forgottenPass.setTitle(forgottenText, for: UIControl.State.normal)
    newUserLabel.setTitle(newUserText, for: UIControl.State.normal)
    buttonLogin.setTitle(buttonLbl, for: UIControl.State.normal)
        plateNumber.setLeftPaddingPoints(25)
        password.setLeftPaddingPoints(25)
 
    }
    func changeLanguage(){
        var languages = languageTranslation().englishLanguage
              
        if (userDefaultLanguage == "ES"){
            languages = languageTranslation().spanishLanguage
        
        }
        if (userDefaultLanguage == "EN"){
            languages = languageTranslation().englishLanguage
        }
        
        if (userDefaultLanguage == "FR"){
            languages = languageTranslation().frenchLanguage
        }
        
        if (userDefaultLanguage == "DE"){
            languages = languageTranslation().germanLanguage
        }
        
        if (userDefaultLanguage == "IT"){
            languages = languageTranslation().italianLanguage
        }
        
        if (userDefaultLanguage == "PT"){
            languages = languageTranslation().portugueseLanguage
        }
        
        if (userDefaultLanguage == "RU"){
            languages = languageTranslation().russianLanguage
        }
        
        if (userDefaultLanguage == "ZH"){
            languages = languageTranslation().chineseLanguage
        }
        
        if (userDefaultLanguage == "JA"){
            languages = languageTranslation().japaneseLanguage
        }
        
        if (userDefaultLanguage == "NL"){
            languages = languageTranslation().dutchLanguage
        }
        
        if (userDefaultLanguage == "PL"){
            languages = languageTranslation().polishLanguage
        }
        if (userDefaultLanguage == "KO"){
            languages = languageTranslation().koreanLanguage
        }
        
        if (userDefaultLanguage == "SV"){
            languages = languageTranslation().swedishLanguage
        }
        if (userDefaultLanguage == "AR"){
            languages = languageTranslation().arabicLanguage
        }
        if (userDefaultLanguage == "UR"){
            languages = languageTranslation().urduLanguage
        }
        if (userDefaultLanguage == "HI"){
            languages = languageTranslation().hindiLanguage
        }
        
        
        plateNumberText = languages["plateHint"]!
        passwordText = languages["password_name"]!
        welcomeText = languages["welcomeMessage"]!
        forgottenText = languages["forgottenPass"]!
        newUserText = languages["newUser"]!
        wrongUser = languages["wrong_user"]!
        buttonLbl = languages["loginLbl"]!
        strongPassLbl = languages["passStrongErr"]!
        profileTab = languages["profile_menu"]!
        chatTab = languages["chat_menu"]!
        notificationsTab = languages["receivedNotifications"]!
        passChangeLbl = languages["passChangeLbl"]!
        newPassHint = languages["newPassHint"]!
        confirmPassHint = languages["confirmPassHint"]!
        strongPass = languages["password_strong"]!
        changePssButton = languages["changePssButton"]!
        cancelText = languages["cancel"]!
        noPassMatch = languages["noPassMatch"]!
        changedPassword = languages["changedPassword"]!
        wrong_password = languages["wrong_password"]!
        
    }
    
    @IBAction func forgotPass(_ sender: Any) {
        let forgotPassSBVC = storyboard?.instantiateViewController(identifier: "passwordReset") as! passwordReset
               
        navigationController?.pushViewController(forgotPassSBVC, animated: true)
        forgotPassSBVC.userLanguageSelected=userDefaultLanguage.uppercased()
    }
    
    @IBAction func newUserAction(_ sender: Any) {
        let newUserSBVC = storyboard?.instantiateViewController(identifier: "newUserSB") as! NewUserViewController
               
        navigationController?.pushViewController(newUserSBVC, animated: true)
        newUserSBVC.userLanguageSelected=userDefaultLanguage.uppercased()
        newUserSBVC.mToken = mToken
    }
    
    
    
}



extension UITextField{
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}


extension UIViewController {
    
func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-100, y: self.view.frame.size.height/2 - 100, width: 220, height: 90))
    toastLabel.backgroundColor = UIColor.white
    toastLabel.textColor = UIColor.black
    toastLabel.font = font
    toastLabel.numberOfLines=3
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    
    self.view.bringSubviewToFront(toastLabel)
    UIView.animate(withDuration: 8.0, delay: 0.8, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
   
  }
}




