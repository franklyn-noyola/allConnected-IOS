//
//  NewUserViewController.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 12/4/21.
//
import FirebaseDatabase
import UIKit
import FirebaseMessaging


class NewUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameField: UITextField!
    
    var plateNumberFieldText : String!
    var emailFieldText : String!
    var noTermsAccepted : String!
    var passwordField : String!
    var welcomeMessage : String!
    var support : String!
    var wrongEmailFormat : String!
    var confirmPasswordField: String!
    var strongPassLbl : String!
    var acceptedTerms : String!
    var registerButtonText : String!
    var registerNewTab : String!
    var languages = languageTranslation().englishLanguage
    var languagesSel = languageTranslation().selectLanguageSP
    var nameText : String!
    var termsLink : String!
    @IBOutlet weak var termsButton: UIButton!
    var userRef : DatabaseReference!
    
    @IBOutlet weak var plateNumberField: UITextField!
    @IBOutlet weak var selectLanguageList: UITableView!
    @IBOutlet weak var selectLanguageButton: UIButton!
    var selectedItem : String!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var confirmPasswordButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordFieldName: UITextField!
    @IBOutlet weak var confirmPasswordName: UITextField!
    var showPass : Bool = false
    var showConfirmPass : Bool = false
    var accepted : Bool = false
    var userLanguageSelected : String!
    var selectLanguageText : String!
    var login : String!
    var allfieldFilled : String!
    var noPassMatch : String!
    var wrong_plate_format : String!
    
    
    @IBOutlet weak var strongPassText: UILabel!
    var selLang : String!
    
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var acceptedCheckBox: UIButton!
    
    func configFields(){
        selectLanguageList.isHidden=true
        let backButton = UIBarButtonItem()
        backButton.title = login
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
      
        plateNumberField.attributedPlaceholder = NSAttributedString(string: plateNumberFieldText, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
        plateNumberField.layer.borderWidth=1
        emailField.attributedPlaceholder = NSAttributedString(string: emailFieldText, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
        emailField.layer.borderWidth=1
        passwordFieldName.layer.borderWidth=1
        passwordFieldName.attributedPlaceholder = NSAttributedString(string: passwordField, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
        confirmPasswordName.layer.borderWidth=1
        confirmPasswordName.attributedPlaceholder = NSAttributedString(string: confirmPasswordField, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
        strongPassText.text = strongPassLbl
        termsButton.layer.borderWidth=0
        termsButton.setTitle(acceptedTerms, for: UIControl.State.normal)
        nameField.attributedPlaceholder = NSAttributedString(string: nameText, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
        nameField.layer.borderWidth=1
        acceptedCheckBox.layer.borderWidth=1
        registerButton.setTitle(registerButtonText, for: UIControl.State.normal)
    }
    var mToken : String = ""
    var languageSelection = [String]()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRef = Database.database().reference()
        self.hideKeyboardWhenTappedAround()
        changeLanguage()
        configFields()
        selectLanguageButton.setTitle(selectLanguageText, for: UIControl.State.normal)
        passwordFieldName.isHidden=true
        plateNumberField.isHidden=true
        strongPassText.isHidden=true
        registerButton.isHidden=true
        acceptedCheckBox.isHidden=true
        termsButton.isHidden=true
        passwordButton.isHidden=true
        confirmPasswordButton.isHidden=true
        nameField.isHidden=true
        passwordFieldName.isSecureTextEntry=true
        confirmPasswordName.isSecureTextEntry=true
        confirmPasswordName.isHidden=true
        emailField.isHidden=true
    }
    
    
    @IBAction func getTermsURL(_ sender: Any) {
        let termsURL = URL(string : termsLink)
        if UIApplication.shared.canOpenURL(termsURL!){
            UIApplication.shared.open(termsURL!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let sendEmail = sendEmail()
        getFromName()
        let plateText = plateNumberField.text!.uppercased()
        if (nameField.text == "" || plateNumberField.text == "" || emailField.text == "" || passwordFieldName.text == "" || confirmPasswordName.text == ""){
            showToast(message: allfieldFilled, font: .systemFont(ofSize: 12.0))
            return
        }
        if (passwordFieldName.text != confirmPasswordName.text){
            showToast(message: noPassMatch, font: .systemFont(ofSize: 14.0))
            return
        }
        if ( plateText.count < 5 || plateText.count > 10)  {
            showToast(message: wrong_plate_format, font: .systemFont(ofSize: 14.0))
            return
        }
        if (accepted==false){
            showToast(message: noTermsAccepted, font: .systemFont(ofSize: 14.0))
            return
        }
        if (!isValidEmail(emailField.text!)){
            showToast(message: wrongEmailFormat, font: .systemFont(ofSize: 14.0))
            return
        }
        if (!isStrongPass(passwordFieldName.text!)){
            showToast(message: strongPassLbl, font: .systemFont(ofSize: 12.0))
            return
        }
        
        let userRefQuery = userRef.child("Users")
        let query = userRefQuery.queryOrdered(byChild: "plate_user").queryEqual(toValue: plateNumberField.text!.uppercased())
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                self.existingPlateErrMsg()
                return
            }else{
               self.saveData()
               self.succesMsg()
               self.setFieldsUnable()
               self.setActivatedUser()
               self.setLangUser()
                sendEmail.sendEmail(usertoSend: self.nameField.text!, recipient: self.emailField.text!.lowercased(), subject: self.welcomeMessage, message: self.sendMessageText(), fromName: self.support)
            }
        }
            
        )
    }
    
    func isValidEmail (_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
        
    func setActivatedUser(){
        self.userRef.child("Users").child("ActivatedUser")  .childByAutoId().setValue(       ["userActivated":plateNumberField.text!.uppercased(),
                    "activated":"OFF",
                    ] as [String : Any])
    }
    
    func setLangUser(){
        self.userRef.child("Users").child("userLanguage").childByAutoId().setValue(       ["users":mToken,
                    "language":userLanguageSelected!,
                ] as [String : Any])       
    }
    
    
    func succesMsg(){
        if (userLanguageSelected=="ES" || selectedItem=="Espa??ol"){
            showToast(message: "El usuario/matr??cula " + plateNumberField.text!.uppercased() + " ha sido registrado, por favor revise su correo electr??nico (Bandeja de entrada o SPAM) para activarlo.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="EN" || selectedItem=="English"){
            showToast(message: "User/Plate number " + plateNumberField.text!.uppercased() + " has been registered, please check your email (Inbox or SPAM) to activate it.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="FR" || selectedItem=="Fran??ais"){
            showToast(message: "Utilisateur/Num??ro de plaque " + plateNumberField.text!.uppercased() + " a ??t?? enregistr??, veuillez v??rifier votre email (Bo??te de r??ception ou SPAM) pour l'activer.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="DE" || selectedItem=="Deutsche"){
            showToast(message: "Benutzer-/Kennzeichen " + plateNumberField.text!.uppercased() + " wurde registriert. Bitte ??berpr??fen Sie Ihre E-Mails (Posteingang oder SPAM), um sie zu aktivieren.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="IT" || selectedItem=="Italiano"){
            showToast(message: "L'utente/numero di targa " + plateNumberField.text!.uppercased() + " ?? stato registrato, controlla la tua email (posta in arrivo o SPAM) per attivarlo.", font: .systemFont(ofSize: 14.0))
            return
        }
        
        if (userLanguageSelected=="PT" || selectedItem=="Portugu??s"){
            showToast(message: "O usu??rio/n??mero do placa " + plateNumberField.text!.uppercased() + " foi registrado, verifique seu e-mail (caixa de entrada ou SPAM) para ativ??-lo.", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="RU" || selectedItem=="??????????????"){
            showToast(message: "????????????????????????/???????????????? ???????? " + plateNumberField.text!.uppercased() + " ?????? ??????????????????????????????, ????????????????????, ?????????????????? ???????? ?????????????????????? ?????????? (???????????????? ?????? ????????), ?????????? ???????????????????????? ??????.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="ZH" || selectedItem=="?????????"){
            showToast(message: "??????/????????? " + plateNumberField
                .text!.uppercased() + " ??????????????????????????????????????????????????????????????????????????????????????????", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="JA" || selectedItem=="?????????"){
            showToast(message: "????????????/?????????????????? " + plateNumberField.text!.uppercased() + " ???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????? ", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="NL" || selectedItem=="Nederlands"){
            showToast(message: "Gebruiker/kenteken " + plateNumberField.text!.uppercased() + " is geregistreerd, controleer uw e-mail (Inbox of SPAM) om deze te activeren.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="PL" || selectedItem=="Polskie"){
            showToast(message: "U??ytkownik/Numer rejestracyjny " + plateNumberField.text!.uppercased() + " zosta?? zarejestrowany, sprawd?? sw??j e-mail (skrzynk?? odbiorcz?? lub SPAM), aby go aktywowa??.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="KO" || selectedItem=="?????????"){
            showToast(message: "?????????/????????? ?????? " + plateNumberField.text!.uppercased() + " ??? ?????????????????????. ?????????????????? ????????? (?????? ????????? ?????? SPAM)??? ??????????????????.", font: .systemFont(ofSize: 11.0))
            return
        }
        
        if (userLanguageSelected=="SV" || selectedItem=="Svenska"){
            showToast(message: "Anv??ndare/plattnummer " + plateNumberField.text!.uppercased() + " har registrerats, kontrollera din e-post (Inbox eller SPAM) f??r att aktivera den.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="AR" || selectedItem=="??????"){
            showToast(message: "???????????????? / ?????? ???????????? " + plateNumberField.text!.uppercased() + "???? ???????????? ?? ???????? ???????????? ???? ?????????? ???????????????????? (?????????? ???????????? ???? ???????????? ????????????????) ??????????????.", font: .systemFont(ofSize: 11.0))
            return
        }
        if (userLanguageSelected=="UR" || selectedItem=="????????"){
            showToast(message: "???????? / ???????? ???????? " + plateNumberField.text!.uppercased() + "???????????? ?????????? ???? ?? ???????? ?????? ?????? ???????? ???????? ???? ?????? ???????? ???? ?????? (???? ???????? ???? ??????????) ?????? ??????????", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="HI" || selectedItem=="???????????????"){
            showToast(message: "?????????????????????????????? / ??????????????? ???????????? " + plateNumberField.text!.uppercased() + " ????????????????????? ???????????? ????????? ??????, ??????????????? ????????? ?????????????????? ???????????? ?????? ????????? ???????????? ???????????? (????????????????????? ?????? ???????????????) ?????????????????? ", font: .systemFont(ofSize: 14.0))
            return
        }
    }
    
    func setFieldsUnable(){
        plateNumberField.isEnabled = false
        termsButton.isEnabled = false
        selectLanguageButton.isEnabled = false
        passwordButton.isEnabled = false
        confirmPasswordButton.isEnabled = false
        emailField.isEnabled = false
        passwordFieldName.isEnabled = false
        confirmPasswordName.isEnabled = false
        registerButton.isEnabled = false
        acceptedCheckBox.isEnabled = false
    }
    
    func existingPlateErrMsg(){
        if (userLanguageSelected=="ES" || selectedItem=="Espa??ol"){
            showToast(message: "El usuario/matricula "+plateNumberField.text!.uppercased()+" ya est?? registrado", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="EN" || selectedItem=="English"){
            showToast(message: "User/Plate Number "+plateNumberField.text!.uppercased()+" is already registered", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="FR" || selectedItem=="Fran??ais"){
            showToast(message: "Utilisateur/Num??ro de plaque " + plateNumberField.text!.uppercased()+" est d??j?? enregistr??", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="DE" || selectedItem=="Deutsche"){
            showToast(message: "Benutzer-/Plattennummer " + plateNumberField.text!.uppercased() + " ist bereits registriert", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="IT" || selectedItem=="Italiano"){
            showToast(message: "Utente/numero di targa " + plateNumberField.text!.uppercased() + " ?? gi?? registrato", font: .systemFont(ofSize: 14.0))
            return
        }
        
        if (userLanguageSelected=="PT" || selectedItem=="Portugu??s"){
            showToast(message: "Usu??rio/n??mero da placa " + plateNumberField.text!.uppercased() + " j?? est?? registrado", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="RU" || selectedItem=="??????????????"){
            showToast(message: "????????????????????????/???????????????? ???????? " + plateNumberField.text!.uppercased() + " ?????? ??????????????????????????????", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="ZH" || selectedItem=="?????????"){
            showToast(message: "??????/?????????" + plateNumberField.text!.uppercased() + " ????????????", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="JA" || selectedItem=="?????????"){
            showToast(message: "????????????/?????????????????? " + plateNumberField.text!.uppercased()        + " ????????????????????????????????????", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="NL" || selectedItem=="Nederlands"){
            showToast(message: "Gebruiker/kenteken " + plateNumberField.text!.uppercased() + " is al geregistreerd", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="PL" || selectedItem=="Polskie"){
            showToast(message: "U??ytkownik/rejestracja " + plateNumberField.text!.uppercased() + " jest ju?? zarejestrowany", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="KO" || selectedItem=="?????????"){
            showToast(message: "?????????/???????????? ?????? " + plateNumberField.text!.uppercased() + "??? ?????? ?????????????????????.", font: .systemFont(ofSize: 14.0))
            return
        }
        
        if (userLanguageSelected=="SV" || selectedItem=="Svenska"){
            showToast(message: "Anv??ndar-/plattnummer " + plateNumberField.text!.uppercased() + " ??r redan registrerad", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="AR" || selectedItem=="??????"){
            showToast(message: "???????????????? / ?????? ???????????? " + plateNumberField.text!.uppercased() + " ?????????? ??????????????", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="UR" || selectedItem=="????????"){
            showToast(message: "???????? / ???????? ???????? " + plateNumberField.text!.uppercased() + " ???????? ???? ???????????? ????", font: .systemFont(ofSize: 14.0))
            return
        }
        if (userLanguageSelected=="HI" || selectedItem=="???????????????"){
            showToast(message: "??????????????????????????????/??????????????? ????????????" + plateNumberField.text!.uppercased() + " ???????????? ?????? ????????????????????? ??????", font: .systemFont(ofSize: 14.0))
            return
        }
    }
    
    func saveData(){
        self.userRef.child("Users").childByAutoId().setValue(       ["plate_user":plateNumberField.text!.uppercased(),
                    "user_email":emailField.text!.lowercased(),
                    "user_name": nameField.text!,
                    "user_password":passwordFieldName.text!,
                    "resetPass":"0",
                    "carbrand":"",
                    "carcolor":"",
                    "carmodel":"",
                    "cartype":"",
                    "year":""
                    ] as [String : Any])
    }
    
    
    @IBAction func acceptedCondAction(_ sender: Any) {
        if (accepted == false){
            acceptedCheckBox.backgroundColor=(UIColor.blue)
            accepted = true;		
            return
        }
        if (accepted == true){
            acceptedCheckBox.backgroundColor=(UIColor.white)
            accepted = false;
            return
        }
    }
    
    @IBAction func password(_ sender: Any) {
        if (showPass == false){
            passwordFieldName.isSecureTextEntry = true
            showPass = true
        
            passwordButton.setImage(UIImage(systemName: "eye"), for: UIControl.State.normal)
            
        return
        }
        if (showPass == true){
            passwordFieldName.isSecureTextEntry = false
            showPass = false
        
            passwordButton.setImage(UIImage(systemName: "eye.slash"), for: UIControl.State.normal)
            
        return
        }
    }
    @IBAction func confirmPass(_ sender: Any) {
        if (showConfirmPass == false){
            confirmPasswordName.isSecureTextEntry = true
            showConfirmPass = true
        
            confirmPasswordButton.setImage(UIImage(systemName: "eye"), for: UIControl.State.normal)
            
        return
        }
        if (showConfirmPass == true){
            confirmPasswordName.isSecureTextEntry = false
            showConfirmPass = false
        
            confirmPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: UIControl.State.normal)
            
        return
        }
    }
    @IBAction func selLanguage(_ sender: Any) {
        if (selectLanguageList.isHidden == true){
            changeLanguage()
            selectLanguageList.isHidden = false
            setFieldsHidden()
        }else{
            selectLanguageList.isHidden = true
            setFieldsVisible()
        }
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageSelection.count
        
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = UITableViewCell (style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cel.textLabel?.text = languageSelection[indexPath.row]
        
        return cel
    }
     
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                    IndexPath){
        tableView.reloadData()
        selectedItem = languageSelection[indexPath.row]
        
        selectLanguageList?.isHidden=true
        
        if (selectedItem == "English" || selectedItem == "Ingl??s" || selectedItem == "Anglais" || selectedItem == "Englisch" || selectedItem == "Inglese" || selectedItem == "Ingl??s" || selectedItem == "????????????????????" || selectedItem == "??????" || selectedItem == "??????" || selectedItem == "Engels" || selectedItem == "J??zyk angielski" || selectedItem == "??????" || selectedItem == "Engelsk" || selectedItem == "????????????????????" || selectedItem == "??????????????" || selectedItem == "???????????????????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("English", for: UIControl.State.normal)
            userLanguageSelected = "EN"
        }
        if (selectedItem == "Spanish" || selectedItem == "Espa??ol" || selectedItem == "Espagnol" || selectedItem == "Spanisch" || selectedItem == "Spagnolo" || selectedItem=="Espanhol" || selectedItem=="??????????????????" || selectedItem == "????????????" || selectedItem == "???????????????" || selectedItem == "Spaans" || selectedItem == "Hiszpa??ski" || selectedItem == "????????????" || selectedItem == "Spanska" || selectedItem == "??????????????????" || selectedItem == "??????????????" || selectedItem == "?????????????????????" ) {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("Espa??ol", for: UIControl.State.normal)
            userLanguageSelected = "ES"
        }
        
        if (selectedItem == "French" || selectedItem == "Franc??s" || selectedItem == "Fran??ais" || selectedItem == "Franz??sisch" || selectedItem == "Francese" || selectedItem=="Franc??s" || selectedItem=="??????????????????????" || selectedItem == "??????" || selectedItem == "???????????????" || selectedItem == "Frans" || selectedItem == "Francuski" || selectedItem == "????????? ??????" || selectedItem == "Franska" || selectedItem == "????????????????" || selectedItem == "????????????????" || selectedItem == "??????????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("Fran??ais", for: UIControl.State.normal)
            userLanguageSelected = "FR"
        }
        
        if (selectedItem == "German" || selectedItem == "Alem??n" || selectedItem == "Allemand" || selectedItem == "Deutsche" || selectedItem == "Tedesco" || selectedItem=="Alem??o" || selectedItem=="????????????????" || selectedItem == "??????" || selectedItem == "????????????" || selectedItem == "Duitse"  || selectedItem == "Niemiecki" || selectedItem == "?????? ??????" || selectedItem == "Tysk" || selectedItem == "??????????????" || selectedItem == "????????" || selectedItem == "???????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("Deutsche", for: UIControl.State.normal)
            userLanguageSelected = "DE"
        }
        
        if (selectedItem == "Italian" || selectedItem == "Italiano" || selectedItem == "Italien" || selectedItem == "Italienisch" || selectedItem == "Italiano"  || selectedItem=="??????????????????????" || selectedItem == "????????????" || selectedItem == "???????????????" || selectedItem == "Italiaans" || selectedItem == "W??oski" || selectedItem == "???????????? ??????" || selectedItem == "Italienska" || selectedItem == "????????????" || selectedItem == "????????????" || selectedItem == "??????????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("Italiano", for: UIControl.State.normal)
            userLanguageSelected = "IT"
        }
        
        if (selectedItem == "Portuguese" || selectedItem == "Portugu??s" || selectedItem == "Portugais" || selectedItem == "Portugiesisch" || selectedItem == "Portoghese" || selectedItem=="Portugu??s" || selectedItem=="??????????????????????????" || selectedItem == "????????????" || selectedItem == "??????????????????" || selectedItem == "Portugees" || selectedItem == "Portugalski" || selectedItem == "????????? ???" || selectedItem == "Portugisiska" || selectedItem == "????????????????????" || selectedItem == "??????????????" || selectedItem == "???????????????????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("Portugu??s", for: UIControl.State.normal)
            userLanguageSelected = "PT"
        }
        
        if (selectedItem == "Russian" || selectedItem == "Ruso" || selectedItem == "Russe" || selectedItem == "Russisch" || selectedItem == "Russo" ||  selectedItem=="??????????????" || selectedItem == "??????" || selectedItem == "?????????" || selectedItem == "Russisch" || selectedItem == "Rosyjski" || selectedItem == "????????????" || selectedItem == "Ryska" || selectedItem == "??????????????" || selectedItem == "????????" || selectedItem == "????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("??????????????", for: UIControl.State.normal)
            userLanguageSelected = "RU"
        }
        
        if (selectedItem == "Chinese" || selectedItem == "Chino" || selectedItem == "Chinois" || selectedItem == "Chinesisch" || selectedItem == "Cinese" ||
                selectedItem == "Chin??s" || selectedItem=="??????????????????" || selectedItem == "?????????" || selectedItem == "?????????" || selectedItem == "Chinese" || selectedItem == "Chi??ski" || selectedItem == "?????????" || selectedItem == "Kinesiska" || selectedItem == "????????" || selectedItem == "????????" || selectedItem == "????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("?????????", for: UIControl.State.normal)
            userLanguageSelected = "ZH"
        }
        
        if (selectedItem == "Japanese" || selectedItem == "Japon??s" || selectedItem == "Japonais" || selectedItem == "Japanisch" || selectedItem == "Giapponese" ||
                selectedItem == "Japon??s" || selectedItem=="????????????????" || selectedItem == "?????????" || selectedItem == "?????????" || selectedItem == "Japans" || selectedItem == "J??zyk japo??ski" || selectedItem == "?????????" || selectedItem == "Japanska" || selectedItem == "??????????????????" || selectedItem == "????????????" || selectedItem == "??????????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("?????????", for: UIControl.State.normal)
            userLanguageSelected = "JA"
        }
        
        if (selectedItem == "Dutch" || selectedItem == "Holand??s" || selectedItem == "N??erlandais" || selectedItem == "Niederl??ndisch" || selectedItem == "Olandese" ||
                selectedItem == "Holand??s" || selectedItem=="?????????????????????????? ????????" || selectedItem == "?????????" || selectedItem == "???????????????" || selectedItem == "Nederlands" || selectedItem == "Holenderski" || selectedItem == "???????????? ??????" || selectedItem == "Nederl??ndska" || selectedItem == "?????????? ??????????????????" || selectedItem == "????" || selectedItem == "??????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("Nederlands", for: UIControl.State.normal)
            userLanguageSelected = "NL"
        }
        
        if (selectedItem == "Polish" || selectedItem == "Polaco" || selectedItem == "Polonais" || selectedItem == "Polieren" || selectedItem == "Polaco" ||
                selectedItem == "Polon??s" || selectedItem=="????????????????" || selectedItem == "??????" || selectedItem == "??????" || selectedItem == "Pools" || selectedItem == "Polskie" || selectedItem == "??????" || selectedItem == "Putsa" || selectedItem == "??????????" || selectedItem == "????????" || selectedItem == "???????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("Polskie", for: UIControl.State.normal)
            userLanguageSelected = "PL"
        }
        
        if (selectedItem == "Korean" || selectedItem == "Coreano" || selectedItem == "Cor??en" || selectedItem == "Koreanisch" || selectedItem == "Coreano" ||
                selectedItem == "Coreano" || selectedItem=="??????????????????" || selectedItem == "?????????" || selectedItem == "?????????" || selectedItem == "Koreaans" || selectedItem == "Korea??ski" || selectedItem == "?????????" || selectedItem == "Koreanska" || selectedItem == "??????????????" || selectedItem == "??????????" || selectedItem == "?????????????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("?????????", for: UIControl.State.normal)
            userLanguageSelected = "KO"
        }
        
        if (selectedItem == "Swedish" || selectedItem == "Sueco" || selectedItem == "Su??dois" || selectedItem == "Schwedisch" || selectedItem == "Svedese" ||
                selectedItem == "Sueco" || selectedItem=="????????????????" || selectedItem == "??????" || selectedItem == "?????????????????????" || selectedItem == "Zweeds" || selectedItem == "Szwedzki" || selectedItem == "????????????" || selectedItem == "Svenska" || selectedItem == "????????????????" || selectedItem == "??????????" || selectedItem == "?????????????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("Svenska", for: UIControl.State.normal)
            userLanguageSelected = "SV"
        }
        
        if (selectedItem == "Arabic" || selectedItem == "Arabe" || selectedItem == "Arabe" || selectedItem == "Arabisch" || selectedItem == "Arabo" ||
                selectedItem == "Arabe" || selectedItem=="????????" || selectedItem == "?????????" || selectedItem == "?????????" || selectedItem == "Arabier" || selectedItem == "Arab" || selectedItem == "???????????? ??????" || selectedItem == "Arabiska" || selectedItem == "????????" || selectedItem == "????????" || selectedItem == "????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("????????", for: UIControl.State.normal)
            userLanguageSelected = "AR"
        }
        
        if (selectedItem == "Urdu" ||  selectedItem == "Ourdou" ||
                selectedItem=="????????" || selectedItem == "????????????" || selectedItem == "??????????????????" ||   selectedItem == "????????????" ||  selectedItem == "??????????????" || selectedItem == "????????" || selectedItem == "???????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("????????", for: UIControl.State.normal)
            userLanguageSelected = "UR"
        }
        
        if (selectedItem == "Hindi" || selectedItem == "Hindu" ||
                selectedItem=="??????????" || selectedItem == "?????????" || selectedItem == "???????????????" ||  selectedItem == "Hinduski" || selectedItem == "?????? ???" || selectedItem == "????????" || selectedItem == "????????" || selectedItem == "??????????????????") {
            languageSelection.removeAll()
            selectLanguageButton.setTitle("??????????????????", for: UIControl.State.normal)
            userLanguageSelected = "HI"
        }
        
        
        
        setFieldsVisible()
        changeLanguage()
        configFields()
    }
    
    func setFieldsVisible(){
        plateNumberField.isHidden=false
        plateNumberField.layer.cornerRadius = 8
        emailField.isHidden=false
        emailField.layer.cornerRadius = 8
        passwordFieldName.isHidden=false
        passwordFieldName.layer.cornerRadius = 8
        confirmPasswordName.isHidden=false
        confirmPasswordName.layer.cornerRadius = 8
        confirmPasswordButton.isHidden=false
        
        passwordButton.isHidden=false
        strongPassText.isHidden=false
        registerButton.isHidden=false
        registerButton.layer.cornerRadius = 8
        acceptedCheckBox.isHidden=false
        nameField.isHidden=false
        nameField.layer.cornerRadius = 8
        termsButton.isHidden=false
    }
    
    func setFieldsHidden(){
        plateNumberField.isHidden=true
        emailField.isHidden=true
        passwordFieldName.isHidden=true
        confirmPasswordName.isHidden=true
        confirmPasswordButton.isHidden=true
        passwordButton.isHidden=true
        nameField.isHidden=true
        strongPassText.isHidden=true
        registerButton.isHidden=true
        acceptedCheckBox.isHidden=true
        termsButton.isHidden=true
        
    }
    
    func changeLanguage(){

        if (userLanguageSelected == "ES"){
            languages = languageTranslation().spanishLanguage
            languagesSel = languageTranslation().selectLanguageSP
            termsLink = "https://www.epicdevelopers.app/2020/11/allconect.html";
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
          
        }
        if (userLanguageSelected == "EN"){
            languages = languageTranslation().englishLanguage
            languagesSel = languageTranslation().selectLanguageEng
            termsLink =  "https://www.epicdevelopers.app/2021/04/terms-and-conditions-of-use-relevant.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "FR"){
            languages = languageTranslation().frenchLanguage
            languagesSel = languageTranslation().selectLanguageFR
            termsLink = "https://www.epicdevelopers.app/2021/04/termes-et-conditions-dutilisation-de.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold) ]
        }
        if (userLanguageSelected == "DE"){
            languages = languageTranslation().germanLanguage
            languagesSel = languageTranslation().selectLanguageDE
            termsLink =  "https://www.epicdevelopers.app/2021/04/allconnected-nutzungsbedingungen.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "IT"){
            languages = languageTranslation().italianLanguage
            languagesSel = languageTranslation().selectLanguageIT
            termsLink = "https://www.epicdevelopers.app/2021/04/termini-e-condizioni-duso-di.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "PT"){
            languages = languageTranslation().portugueseLanguage
            languagesSel = languageTranslation().selectLanguagePT
            termsLink = "https://www.epicdevelopers.app/2021/04/termos-e-condicoes-de-uso-de.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "RU"){
            languages = languageTranslation().russianLanguage
            languagesSel = languageTranslation().selectLanguageRU
            termsLink = "https://www.epicdevelopers.app/2021/04/allconnected_15.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "ZH"){
            languages = languageTranslation().chineseLanguage
            languagesSel = languageTranslation().selectLanguageZH
            termsLink = "https://www.epicdevelopers.app/2021/04/blog-post.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "JA"){
            languages = languageTranslation().japaneseLanguage
            languagesSel = languageTranslation().selectLanguageJA
            termsLink = "https://www.epicdevelopers.app/2021/04/allconnected-japones.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "NL"){
            languages = languageTranslation().dutchLanguage
            languagesSel = languageTranslation().selectLanguageNL
            termsLink =  "https://www.epicdevelopers.app/2021/04/gebruiksvoorwaarden-allconnected.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "PL"){
            languages = languageTranslation().polishLanguage
            languagesSel = languageTranslation().selectLanguagePL
            termsLink = "https://www.epicdevelopers.app/2021/04/warunki-uzytkowania-allconnected-polaco.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "KO"){
            languages = languageTranslation().koreanLanguage
            languagesSel = languageTranslation().selectLanguageKO
            termsLink = "https://www.epicdevelopers.app/2021/04/allconnected_77.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "SV"){
            languages = languageTranslation().swedishLanguage
            languagesSel = languageTranslation().selectLanguageSV
            termsLink = "https://www.epicdevelopers.app/2021/04/allconnected-anvandarvillkor-sueco.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "AR"){
            languages = languageTranslation().arabicLanguage
            languagesSel = languageTranslation().selectLanguageAR
            termsLink = "https://www.epicdevelopers.app/2021/04/allconnected.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "UR"){
            languages = languageTranslation().urduLanguage
            languagesSel = languageTranslation().selectLanguageUR
            termsLink = "https://www.epicdevelopers.app/2021/04/urdu.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold) ]
        }
        
        if (userLanguageSelected == "HI"){
            languages = languageTranslation().hindiLanguage
            languagesSel = languageTranslation().selectLanguageHI
            termsLink = "https://www.epicdevelopers.app/2021/04/blog-post_15.html"
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: UIFont.Weight.bold) ]
        }
        
        plateNumberFieldText = languages["plateHint"]!
        emailFieldText = languages["email_name"]!
        passwordField = languages["password_name"]!
        confirmPasswordField = languages["confirm_password"]!
        strongPassLbl = languages["passStrongErr"]!
        acceptedTerms = languages["acceptedTerms"]!
        registerButtonText = languages["register"]!
        registerNewTab = languages["new_user"]!
        login = languages["loginLbl"]!
        allfieldFilled = languages["allfieldFilled"]!
        noPassMatch = languages["noPassMatch"]!
        selectLanguageText = languages["selectLanguage"]!
        languageSelection = languagesSel
        nameText = languages["name"]!
        noTermsAccepted = languages["noTermsAccepted"]!
        title = registerNewTab
        wrong_plate_format = languages["wrong_plate_format"]!
        welcomeMessage = languages["welcomeMessage"]!
        wrongEmailFormat = languages["wrongEmailFormat"]!
      
    }
    
    func getFromName(){
        if (userLanguageSelected=="ES"){
            support = "Soporte allConnected"
        }else{
            support = "allConnected Support"
        }
    }
    
    func sendMessageText() -> String {
        var allMessage : String = ""
        var welcomeMessage : String = ""
        var headerMessage : String = ""
        var bodyMessage : String = ""
        var farewellMessage : String = ""
        if (userLanguageSelected=="ES"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">Bienvenido/a a allConnected!!!</font></b><br><br>";
            headerMessage="Estimado Sr./Sra "+nameField.text!+"<br><br>";
            bodyMessage="Gracias por registrarse en el mundo de allConnected. Para activar el usuario, haga click en este link: <a href=http://epicdevelopers.es?ES"+plateNumberField.text!.uppercased()  + ">Activar usuario</a> <br><br>";
            farewellMessage="Un saludo cordial,<br>El equipo de allConnected.";
            allMessage = welcomeMessage+headerMessage+bodyMessage+farewellMessage
        }
        if (userLanguageSelected=="EN"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">Welcome to allConnected!!!</font></b><br><br>";
            headerMessage="Dear Mr/Mrs. "+nameField.text! + "<br><br>";
            bodyMessage="Thanks for regisgtering to allConnected world. To activate your account, click on this link: <a href=http://epicdevelopers.es?EN"+plateNumberField.text!.uppercased()  + ">Activate account</a> <br><br>";
            farewellMessage="Truly yours,<br>allConnected Team.";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage
        }
        if (userLanguageSelected=="FR"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">Benvenuto in allConnected!!!</font></b><br><br>";
            headerMessage="Caro signor/signora "+nameField.text! + "<br><br>";
            bodyMessage="Grazie per esserti registrato a allConnected world. Per attivare il tuo utente, fare clic su questo collegamento: <a href=http://epicdevelopers.es?IT"+plateNumberField.text!.uppercased() + ">Attiva utente</a> <br><br>";
            farewellMessage="Cordiali saluti,<br>Il team allConnected.";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
        if (userLanguageSelected=="DE"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">Willkommen bei allConnected!!!</font></b><br><br>";
            headerMessage="Sehr geehrter Herr/Frau "+nameField.text! + "<br><br>";
            bodyMessage="Vielen Dank, dass Sie sich bei allConnected world registriert haben. Kopieren Sie diesen Aktivierungscode, klicken Sie auf diesen Link: <a href=http://epicdevelopers.es?DE"+plateNumberField.text!.uppercased() + ">Benutzer aktivieren</a> <br><br>";
            farewellMessage="Mit freundlichen Gr????en,<br>Das allConnected-Team.";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
             
        if (userLanguageSelected=="IT"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">Bem-vindo a allConnected!!!</font></b><br><br>";
            headerMessage="Prezado Sr./Sra. " + nameField.text! + "<br><br>";
            bodyMessage="Obrigado por se registrar no mundo de allConnected. Para ativar o usu??rio, clique neste link: <a href=http://epicdevelopers.es?PT"+plateNumberField.text!.uppercased() + ">Ativar usu??rio</a> <br><br>";
            farewellMessage="Sinceramente,<br>A equipe allConnected.";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
        if (userLanguageSelected=="PT"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">Bem-vindo a allConnected!!!</font></b><br><br>";
            headerMessage="Prezado Sr./Sra. " + nameField.text! + "<br><br>"
            bodyMessage="Obrigado por se registrar no mundo de allConnected. Para ativar o usu??rio, clique neste link: <a href=http://epicdevelopers.es?PT" + plateNumberField.text!.uppercased() + ">Ativar usu??rio</a> <br><br>"
            farewellMessage="Sinceramente,<br>A equipe allConnected."
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage
        }
         if (userLanguageSelected=="RU"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">?????????? ???????????????????? ?? allConnected!!!</font></b><br><br>";
            headerMessage="?????????????????? ????????????????/?????????????? " + nameField.text! + "<br><br>"
            bodyMessage="?????????????? ???? ?????????????????????? ?? ???????? allConnected. ?????????? ???????????????????????? ???????? ?????????????? ????????????, ?????????????? ???? ?????? ????????????: <a href=http://epicdevelopers.es?RU" + plateNumberField.text!.uppercased() + ">???????????????????????? ????????????????????????</a> <br><br>"
            farewellMessage="????????????????,<br>?????????????? allConnected."
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
        if (userLanguageSelected=="ZH"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">????????????allConnected!!!</font></b><br><br>";
            headerMessage="???????????????/????????? " + nameField.text! + "<br><br>";
            bodyMessage="?????????????????????????????????????????????????????????????????????????????????:<a href=http:/epicdevelopers.es?ZH" + plateNumberField.text!.uppercased() + ">????????????</a> <br><br>";
            farewellMessage="???????????????,<br>???????????? allConnected???";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
       if (userLanguageSelected=="JA"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">allConnected???????????????!!!</font></b><br><br>";
            headerMessage="????????????????????????/?????????" + nameField.text! + "<br><br>";
            bodyMessage="allConnectedworld??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????<a href=http:/epicdevelopers.es?JA" + plateNumberField.text!.uppercased() + ">?????????????????????????????????</a> <br><br>";
            farewellMessage="?????????,<br>allConnected????????????"
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
        if (userLanguageSelected=="NL"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">Welkom bij allConnected!!!</font></b><br><br>";
            headerMessage="Beste meneer/mevrouw. " + nameField.text! + "<br><br>";
            bodyMessage="Bedankt voor uw aanmelding bij allConnected world. Om uw account te activeren, klikt u op deze link: <a href=http://epicdevelopers.es?NL" + plateNumberField.text!.uppercased() + "> Activeer gebruiker</a> <br><br>";
            farewellMessage="Oprecht,<br>Het allConnected -team.";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
         }
         if (userLanguageSelected=="PL"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">Witamy w allConnected!!!</font></b><br><br>";
            headerMessage="Szanowny Panie/Pani.. " + nameField.text! + "<br><br>";
            bodyMessage="Bedankt voor uw aanmelding bij allConnected world. Om uw account te activren, kliknij ten link: <a href=http://epicdevelopers.es?PL" + plateNumberField.text!.uppercased() + ">Activeer gebruiker</a> <br><br>";
            farewellMessage="Z powa??aniem,<br>Zesp???? allConnected.";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
        if (userLanguageSelected=="KO"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">allConnected??? ?????? ?????? ???????????????!!!</font></b><br><br>";
            headerMessage="???????????? Mr./Ms. " + nameField.text! + "<br><br>";
            bodyMessage="allConnected??? ????????? ?????? ??? ????????? ???????????????. ????????? ????????????????????? ????????? ??????????????????.: <a href= http://epicdevelopers.es?KO" + plateNumberField.text!.uppercased() + "> ????????? ?????????</a> <br><br>";
            farewellMessage="????????????,<br>allConnected ???.";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
         }
        if (userLanguageSelected=="SV"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">V??lkommen till allConnected!!!</font></b><br><br>";
            headerMessage="K??ra herr/fru. " + nameField.text! + "<br><br>";
            bodyMessage="Tack f??r att du registrerade dig i allConnected-v??rlden. F??r att aktivera anv??ndaren, klicka p?? den h??r l??nken: <a href=http://epicdevelopers.es?SV" + plateNumberField.text!.uppercased() + "> Aktivera anv??ndare</a> <br><br>";
            farewellMessage="v??nliga h??lsningar,<br>AllConnected-teamet.";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
        if (userLanguageSelected=="HI"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">allConnected ????????? ???????????? ?????????????????? ??????!!!</font></b><br><br>";
            headerMessage="??????????????? ???????????? / ????????? ????????? " + nameField.text! + "<br><br>";
            bodyMessage="allConnected ?????????????????? ?????? ????????? regisgtering ?????? ????????? ???????????????????????? ???????????? ???????????? ?????? ?????????????????? ???????????? ?????? ?????????, ?????? ???????????? ?????? ??????????????? ????????????: <a href=http://epicdevelopers.es?HI" + plateNumberField.text!.uppercased() + "> ?????????????????????????????? ?????? ?????????????????? ????????????</a> <br><br>";
            farewellMessage="???????????????????????? ??????,<br>allConnected ?????????.";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
         }
         if (userLanguageSelected=="AR"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">" +
                           "???????????? ???? ???? allConnected"+"!!!</font></b><br><br>";
            headerMessage="" +
                           "?????????? ?????????? / ????????????."
                + nameField.text! + "<br><br>";
            bodyMessage = "?????????? ?????? ?????????????? ???? allConnected world. ???????????? ?????????? ?? ???????? ?????? ?????? ????????????????" +
                    "<a href=http://epicdevelopers.es?AR" + plateNumberField.text!.uppercased() + ">" +  "?????????? ????????????????" + "</a> <br><br>" ;
            farewellMessage="????????????"+"<br"+"???????? allConnected";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
        if (userLanguageSelected=="UR"){
            welcomeMessage="<b><font size=\"20\" color=\"blue\">"+"allCnnected ?????? ?????? ??????????"+"</font></b><br><br>";
            headerMessage=" ?????????? ???????? / ???????????? " + nameField.text! + "<br><br>";
            bodyMessage = "allConnected ???????? ?????? ???????????? ???????? ???? ???????????? ???????? ???????????? ???? ???????? ???????? ???? ?????? ?? ???? ?????? ???? ?????? ????????"+"<a href=http://epicdevelopers.es?UR" + plateNumberField.text!.uppercased() + ">" + "???????? ???? ???????? ????????"+"</a> <br><br>";
            farewellMessage="????????,"+"<br>"+"???? ???? ?????????? ????????";
            allMessage=welcomeMessage+headerMessage+bodyMessage+farewellMessage;
        }
        return allMessage
    }
   

}

extension UIViewController {
    func isStrongPass (_ password: String) -> Bool {
        let passRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let pass = NSPredicate(format:"SELF MATCHES %@ ", passRegex )
        return pass.evaluate(with: password)
    }
}
