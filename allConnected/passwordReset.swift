//
//  passwordReset.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 13/4/21.
//

import UIKit
import FirebaseDatabase
import Firebase
import Security

class passwordReset: UIViewController {

    @IBOutlet weak var plateField: UITextField!
    
    
    @IBOutlet weak var resetButtonLbl: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    var passwordGen : String!
    var languages = languageTranslation().englishLanguage
    var userLanguageSelected : String!
    var userName : String!
    var generatedPass : String!
    var passResetMsg : String!
    var plateNumberFieldText : String!
    var emailFieldText : String!
    var emptyFields : String!
    var resetTextButton : String!
    var passResetLbl : String!
    var plate : String!
    var email : String!
    var noExists : String!
    var login : String!
    var support : String!
    var passRef : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage()
        passRef = Database.database().reference()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
                                         
        let backButton = UIBarButtonItem()
        backButton.title = login
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
       configureFields()
    }
    
    @IBAction func resetButton(_ sender: Any) {
        plate = plateField.text!
        email = emailField.text!
        if (plate.isEmpty || email.isEmpty){
            showToast(message: emptyFields, font: .systemFont(ofSize: 12.0))
            return
        }else{
            self.getData()
        }
    }
    func getFromName(){
        if (userLanguageSelected=="ES"){
            support = "Soporte allConnected"
        }else{
            support = "allConnected Support"
        }
    }
    
    func getData() {
        getFromName()
        var emailSel : String = ""
        var key : String = ""
        let userRefQuery = passRef.child("Users")
        
        let query = userRefQuery.queryOrdered(byChild: "plate_user").queryEqual(toValue: plate.uppercased())
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.exists()){
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    key = snap.key
                    let getEmail = snap.value as! [String : Any]
                    emailSel = getEmail["user_email"] as? String ?? ""
                    self.userName = getEmail["user_name"] as? String ?? ""
                }
               
                if (emailSel != self.email){
                    self.emailErr()
                }else{
                    let genPass = SecCreateSharedWebCredentialPassword() as String?
                    self.passwordGen = genPass!
                    self.passRef.child("Users").child(key).updateChildValues(["user_password": genPass!,
                                                                          "resetPass": "1"])
                   }
                self.showToast(message: self.passResetMsg, font: .systemFont(ofSize: 12.0))
                self.emailField.isEnabled = false
                self.plateField.isEnabled = false
                self.resetButtonLbl.isEnabled = false
                let sendEmail = sendEmail()
                sendEmail.sendEmail(usertoSend: self.userName, recipient: self.email.lowercased(), subject: self.generatedPass, message: self.sendMessage(), fromName: self.support)
            }else{
                self.noExistUser()
            }
        })
    }
    
    private func noExistUser(){
        if (userLanguageSelected=="ES") {
            showToast(message: "El usuario/matrícula " + plate.uppercased() + " no existe o no ha sido registrado.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="EN") {
            showToast(message: "User/Plate Number " + plate.uppercased() + " does not exist or hasn't registered yet.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="FR") {
            showToast(message: "Utilisateur/Numéro de plaque " + plate.uppercased() + " n'existe pas ou ne s'est pas encore inscrit.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="DE") {
            showToast(message: "Benutzer-/Kennzeichen " + plate.uppercased() + " existiert nicht oder hat sich noch nicht registriert.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="IT") {
            showToast(message: "L'utente/numero di targa " + plate.uppercased() + " non esiste o non si è ancora registrato.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="PT") {
            showToast(message: "O usuário/número do placa " + plate.uppercased() + " não existe ou não foi registrado.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="RU") {
            showToast(message: "Пользователь/номерной знак " + plate.uppercased() + " не существует или не был зарегистрирован.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="ZH") {
            showToast(message: "用户/车牌号 " + plate.uppercased() + " 不存在或尚未注册。", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="JA") {
            showToast(message: "ユーザー/プレート番号 " + plate.uppercased() + " が存在しないか、登録されていません。", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="NL") {
            showToast(message: "Gebruiker/kenteken " + plate.uppercased() + " bestaat niet of is niet geregistreerd.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="PL") {
            showToast(message: "Użytkownik/Numer rejestracyjny " + plate.uppercased() + " nie istnieje lub nie został zarejestrowany.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="KO") {
            showToast(message: "사용자/번호판 번호 " + plate.uppercased() + " 가 존재하지 않거나 등록되지 않았습니다.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="SV") {
            showToast(message: "Användare/plattnummer " + plate.uppercased() + " finns inte eller har inte registrerats.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="AR") {
            showToast(message: "المستخدم / رقم اللوحة " + plate.uppercased() + " غير موجود أو لم يتم تسجيله.", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="UR") {
            showToast(message: "صارف / پلیٹ نمبر " + plate.uppercased() + " موجود نہیں ہے یا رجسٹرڈ نہیں کیا گیا ہے۔", font: .systemFont(ofSize: 12.0))
        }
        if (userLanguageSelected=="HI") {
            showToast(message: "उपयोगकर्ता / प्लेट नंबर " + plate.uppercased() + " मौजूद नहीं है या पंजीकृत नहीं किया गया है।", font: .systemFont(ofSize: 12.0))
        }
    }
        private func emailErr() {
            if (userLanguageSelected=="ES") {
                showToast(message: "El email " + email + " no corresponde con el usuario/matrícula "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="EN") {
                showToast(message: "Email " + email + " does not belong to user/plate number "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="FR") {
                showToast(message: "Email " + email + " n'appartient pas à l'utilisateur "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="DE") {
                showToast(message: "Email " + email + " gehört nicht dem Benutzer "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="IT") {
                showToast(message: "Email " + email + " non appartiene all'utente "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="PT") {
                showToast(message: "O email " + email + " não corresponde ao usuário "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="RU") {
                showToast(message: "Электронная почта " + email + " не соответствует пользователю "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="ZH") {
                showToast(message: "电子邮件  " + "与用户" + plate.uppercased() + " 不对应", font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="JA") {
                showToast(message: "Eメール " + email + " はユーザーに対応していません "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="NL") {
                showToast(message: "De e-mail " + email + " komt niet overeen met de gebruiker "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="PL") {
                showToast(message: "Adres e-mail " + email + " nie odpowiada użytkownikowi "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="KO") {
                showToast(message: "이메일 " + email + " 이 사용자와 일치하지 않습니다. "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="SV") {
                showToast(message: "E-postmeddelandet " + email + " motsvarar inte användaren "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="AR") {
                showToast(message: "البريد الإلكتروني" + email + "موتسفارار انفاندارين "  + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="UR") {
                showToast(message: "ای میل " + email + " صارف سے مطابقت نہیں رکھتا ہے " + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
            if (userLanguageSelected=="HI") {
                showToast(message: "ईमेल " + email + " उपयोगकर्ता के अनुरूप नहीं है "   + plate.uppercased(), font: .systemFont(ofSize: 12.0))
            }
        }
        
    
    
    private func configureFields(){
       emailField.layer.cornerRadius = 8
        emailField.layer.borderWidth=1
        plateField.layer.borderWidth = 1
        emailField.layer.cornerRadius = 8
        emailField.attributedPlaceholder = NSAttributedString(string: emailFieldText, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
        plateField.attributedPlaceholder = NSAttributedString(string: plateNumberFieldText, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.black])
      
          plateField.setLeftPaddingPoints(35)
          emailField.setLeftPaddingPoints(35)
        resetButtonLbl.setTitle(resetTextButton, for: UIControl.State.normal)
        resetButtonLbl.layer.cornerRadius = 8
        emailField.placeholder = emailFieldText
        plateField.placeholder = plateNumberFieldText
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
        
        plateNumberFieldText = languages["plateHint"]!
        emailFieldText = languages["email_name"]!
        resetTextButton = languages["reset"]!
        emptyFields = languages["noEmptyFields"]!
        passResetLbl = languages["passResetLbl"]!
        login = languages["loginLbl"]!
        noExists = languages["noExists"]!
        passResetMsg = languages["passResetMsg"]!
        generatedPass = languages["generatedPass"]!
        
        title = passResetLbl
        
    }
    
    private func sendMessage() -> String {
        var messageHeader : String = ""
        var messabeBody1 : String = ""
        var messageFarawell : String = ""
        var allMessages : String = ""
        
        if (userLanguageSelected=="ES"){
            messageHeader = "Estimado Sr./Sra. " + userName + "<br><br>";
            messabeBody1="Su contraseña <strong>" + passwordGen + "</strong> ha sido generada automáticamente. Ir a la app allConnected y una vez en el inicio introducir la matrícula y la contraseña generada, " +
                     "y hacer clic al botón LOGIN. Luego aparecerá una pantalla para que introduzca su nueva contraseña, ya que la contraseña generada es temporal.<br> Una vez en la pantalla de cambio de contraseña, " +
                     "cambie a una contraseña que elijas y una vez cambiada vaya al inicio de la aplicación y loguese con su nueva contraseña.<br><br> Para cualquier duda o consulta, no dude en contactarnos vía soporte<br><br>";
             messageFarawell="Un saludo cordial,<br>El equipo de allConnected.";
             allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="EN"){
                messageHeader = "Dear Mr./Mrs. " + userName + "<br><br>";
                messabeBody1="Your password <strong>" + passwordGen + "</strong> has been generated automatically. Please, go to allConnected app and type the plate number (your account) and the generated password, " +
                            "and click on LOGIN button. Afterwards, another screen will be displayed so you can enter your new password, this is why the generated password is for temporal use.<br> Once, in the Change Password screen, " +
                            "change your password for another password you select and once it has been changed you can enter in allConnected app.<br><br> For any doubt or comment, don't hesitate to contact with Support Team.<br><br>";
                messageFarawell="Truly yours,<br>allConnected Team.";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="FR"){
                messageHeader = "Cher Monsieur/Madame " + userName + "<br><br>";
                messabeBody1="Votre mot de passe <strong>" + passwordGen + "</strong> a été généré automatiquement. S'il vous plaît, allez sur l'application allConnected et tapez le numéro de plaque (votre compte) et le mot de passe généré " +
                            "et cliquez sur le bouton LOGIN. Ensuite, un autre écran s'affichera pour que vous puissiez saisir votre nouveau mot de passe, c'est pourquoi le mot de passe généré est à usage temporaire.<br> Une fois, dans l'écran Modifier le mot de passe, " +
                            "changez votre mot de passe pour un autre mot de passe que vous sélectionnez et une fois qu'il a été changé, vous pouvez entrer dans l'application allConnected.<br><br> Pour tout doute ou commentaire, n'hésitez pas à contacter l'équipe de support.<br><br>";
             
                    messageFarawell="Cordialement,<br>L'équipe allConnected.";
                    allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="DE"){
                messageHeader = "Sehr geehrter Herr/Frau " + userName + "<br><br>";
                messabeBody1="Ihr Passwort <strong>" + passwordGen + "</strong> wurde automatisch generiert. Bitte gehen Sie zur allConnected App und geben Sie die Kennzeichen (Ihr Konto) und das generierte Passwort ein " +
                            "und klicken Sie auf die Schaltfläche LOGIN. Anschließend wird ein weiterer Bildschirm angezeigt, in dem Sie Ihr neues Passwort eingeben können. Aus diesem Grund ist das generierte Passwort für die vorübergehende Verwendung vorgesehen.<br> Einmal im Bildschirm Passwort ändern, " +
                            "Ändern Sie Ihr Passwort für ein anderes Passwort, das Sie auswählen. Sobald es geändert wurde, können Sie es in die allConnected-App eingeben.<br><br> Bei Zweifeln oder Kommentaren wenden Sie sich bitte an das Support-Team.<br><br>";
                messageFarawell="Mit freundlichen Grüßen,<br>Das allConnected-Team.";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="IT"){
                messageHeader = "Caro signor/signora " + userName + "<br><br>";
                messabeBody1="La tua password <strong>" + passwordGen + "</strong> è stato generato automaticamente. Per favore, vai all'app allConnected e digita il numero di targa (il tuo account) e la password generata, " +
                            "e fare clic sul pulsante LOGIN. Successivamente, verrà visualizzata un'altra schermata in cui puoi inserire la tua nuova password, questo è il motivo per cui la password generata è per uso temporaneo.<br> Una volta, nella schermata Cambia password, " +
                            "cambia la tua password per un'altra password che hai selezionato e una volta che è stata cambiata puoi entrare nell'app allConnected.<br><br> Per qualsiasi dubbio o commento, non esitare a contattare il team di supporto.<br><br>";
                messageFarawell="Cordiali saluti,<br>Il team allConnected.";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="PT"){
                messageHeader = "Prezado Sr./Sra. " + userName + "<br><br>";
                messabeBody1="Sua senha <strong>" + passwordGen + "</strong> foi gerado automaticamente. Vá para o aplicativo allConnected e, uma vez no início, insira a placa do carro e a senha gerada, " +
                            "e clique no botão LOGIN. Em seguida, aparecerá uma tela para você inserir sua nova senha, pois a senha gerada é temporária. <br> Uma vez na tela de alteração de senha, " +
                            "mude para uma senha de sua escolha e uma vez alterada vá para o início do aplicativo e faça o login com sua nova senha. <br> <br> Em caso de dúvidas ou consultas, não hesite em nos contatar através do suporte.<br><br>";
                messageFarawell="Atenciosamente, <br> Equipe allConnected.";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="NL"){
                messageHeader = "Beste meneer/mevrouw " + userName + "<br><br>";
                messabeBody1="Uw wachtwoord <strong>" + passwordGen + "</strong> is automatisch gegenereerd. Ga alsjeblieft naar de app allConnected en typ het kenteken (je account) en het gegenereerde wachtwoord, " +
                            "en klik op LOGIN. Daarna wordt een ander scherm weergegeven zodat u uw nieuwe wachtwoord kunt invoeren, daarom is het gegenereerde wachtwoord voor tijdelijk gebruik. <br> Eenmaal, in het scherm Wachtwoord wijzigen, " +
                            "verander uw wachtwoord voor een ander wachtwoord dat u selecteert en zodra het is gewijzigd, kunt u dit invoeren in de allConnected-app. <br> <br> Aarzel niet om contact op te nemen met het ondersteuningsteam bij twijfel of opmerkingen.<br><br>";
                messageFarawell="oprecht,<br>Het allConnected-team.";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="RU"){
                messageHeader = "Уважаемый господин /госпожа. " + userName + "<br><br>";
                messabeBody1="Ваш пароль <strong> " + passwordGen + " </strong> был создан автоматически. Пожалуйста, зайдите в приложение allConnected и введите номер телефона (ваш аккаунт) и сгенерированный пароль., " +
                            "и нажмите кнопку ВХОД. После этого появится другой экран, на котором вы сможете ввести свой новый пароль, поэтому сгенерированный пароль предназначен для временного использования. <br> Один раз на экране «Изменить пароль», " +
                            "измените свой пароль на другой выбранный вами пароль, и как только он будет изменен, вы сможете ввести его в приложении allConnected. <br> <br> Если у вас возникнут сомнения или комментарии, не стесняйтесь обращаться в службу поддержки.<br><br>";
                    messageFarawell="Искренне,<br>Команда allConnected.";
                    allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="ZH"){
                messageHeader = "尊敬的先生/夫人： " + userName + "<br><br>";
                messabeBody1="您的密码<strong>" + passwordGen + " </strong>已自动生成。请转到allConnected应用并输入车牌号（您的帐户）和生成的密码, " +
                            "然后单击“登录”按钮。之后，将显示另一个屏幕，以便您输入新密码，这就是为什么生成的密码仅供临时使用的原因。一次，在“更改密码”屏幕中。, " +
                            "将您的密码更改为您选择的另一个密码，更改后即可输入allConnected应用程序。<br> <br>如有任何疑问或意见，请随时与支持团队联系。.<br><br>";
                messageFarawell="Truly yours,<br>allConnected Team.";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="JA"){
                messageHeader = "親愛なるサー/マダム " + userName + "<br><br>";
                messabeBody1="パスワード<strong>" + passwordGen + "</strong>は自動的に生成されました。 allConnectedアプリに移動し、プレート番号（アカウント）と生成されたパスワードを入力してください, " +
                            "ログインボタンをクリックします。その後、別の画面が表示され、新しいパスワードを入力できます。これが、生成されたパスワードが一時的に使用される理由です。一度、パスワードの変更画面で, " +
                            "選択した別のパスワードにパスワードを変更すると、allConnectedアプリに入力できます。<br> <br>疑問やコメントがある場合は、遠慮なくサポートチームに連絡してください。.<br><br>";
                messageFarawell="心から,<br>allConnectedチーム。";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="PL"){
                messageHeader = "Szanowny Panie /Pani. " + userName + "<br><br>";
                messabeBody1="Twoje hasło <strong> " + passwordGen + " </strong> zostało wygenerowane automatycznie. Przejdź do aplikacji allConnected i od razu na początku wprowadź numer rejestracyjny oraz wygenerowane hasło, " +
                            "i kliknij przycisk LOGIN. Następnie pojawi się ekran, na którym należy wprowadzić nowe hasło, ponieważ wygenerowane hasło jest tymczasowe.<br> Na ekranie zmiany hasła " +
                            "zmień na wybrane przez siebie hasło, a po zmianie przejdź na początek aplikacji i zaloguj się przy użyciu nowego hasła. <br> <br> W przypadku jakichkolwiek pytań lub pytań prosimy o kontakt poprzez support<br><br>";
                messageFarawell="Z poważaniem,<br>Zespół allConnected.";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="KO"){
                messageHeader = "친애하는 Mr./Mrs. " + userName + "<br><br>";
                messabeBody1="비밀번호 <strong> " + passwordGen + "</strong>이 자동으로 생성되었습니다. allConnected 앱으로 이동하여 처음에 번호판과 생성 된 비밀번호를 입력합니다 " +
                            "로그인 버튼을 클릭합니다. 생성 된 비밀번호는 임시이므로 새 비밀번호를 입력하는 화면이 나타납니다. <br> 비밀번호 변경 화면에서 " +
                            "원하는 암호로 변경하고 변경 한 후에는 응용 프로그램 시작으로 이동하여 새 암호로 로그인하십시오. <br> <br> 질문이나 질문이 있으시면 언제든지 지원을 통해 저희에게 연락하십시오.<br><br>";
                messageFarawell="진정으로<br>allConnected 팀";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="SV"){
                messageHeader = "Kära herr/fru " + userName + "<br><br>";
                messabeBody1="Ditt lösenord <strong> " + passwordGen + " </strong> har genererats automatiskt. Gå till allConnected-appen och ange registreringsskylten och det genererade lösenordet en gång i början, " +
                            "och klicka på LOGGA IN-knappen. Då visas en skärm där du kan ange ditt nya lösenord, eftersom det genererade lösenordet är tillfälligt. <br> En gång på skärmen för lösenordsbyte, " +
                            "byt till ett lösenord som du väljer och när det har ändrats går du till applikationens start och loggar in med ditt nya lösenord. <br> <br> För frågor eller frågor, tveka inte att kontakta oss via support.<br><br>";
                messageFarawell="Vänliga hälsningar,<br>allConnected-teamet.";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="HI"){
                messageHeader = "प्रिय श्री/श्रीमती। " + userName + "<br><br>";
                messabeBody1="आपका पासवर्ड <strong> " + passwordGen + " </strong> अपने आप उत्पन्न हो गया है। AllConnected ऐप पर जाएं और शुरुआत में एक बार लाइसेंस प्लेट और जनरेट किए गए पासवर्ड को दर्ज करें " +
                            "और LOGIN बटन पर क्लिक करें। तब आपके लिए अपना नया पासवर्ड दर्ज करने के लिए एक स्क्रीन दिखाई देगी, क्योंकि उत्पन्न पासवर्ड अस्थायी है। पासवर्ड परिवर्तन स्क्रीन में एक बार " +
                            "अपनी पसंद के पासवर्ड को बदलने और एक बार बदले जाने के बाद एप्लिकेशन की शुरुआत में जाएं और अपने नए पासवर्ड के साथ लॉग इन करें। <br> <br> किसी भी प्रश्न या प्रश्न के लिए, समर्थन के माध्यम से हमसे संपर्क करने में संकोच न करें।<br><br>";
                messageFarawell="ईमानदारी से<br>allConnected टीम";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="AR"){
                messageHeader = "عزيزي السيد / السيدة. " + userName + "<br><br>";
                messabeBody1="كلمة السر خاصتك "+"<strong>" + passwordGen + "</strong>"+" تم إنشاؤه تلقائيًا. انتقل إلى تطبيق allConnected ومرة واحدة في البداية أدخل لوحة الترخيص وكلمة المرور التي تم إنشاؤها " +
                           "وانقر على زر تسجيل الدخول. ثم ستظهر لك شاشة لإدخال كلمة المرور الجديدة ، لأن كلمة المرور التي تم إنشاؤها مؤقتة. "+"<br>"+" بمجرد ظهور شاشة تغيير كلمة المرور ، " +
                           "قم بالتغيير إلى كلمة مرور من اختيارك وبمجرد تغييرها ، انتقل إلى بدء التطبيق وقم بتسجيل الدخول باستخدام كلمة المرور الجديدة."+"<br><br>"+"لأية أسئلة أو استفسارات ، لا تتردد في الاتصال بنا عبر الدعم<br><br>";
                messageFarawell="بإخلاص"+"<br>"+"فريق allConnected";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        if (userLanguageSelected=="UR"){
                messageHeader = "محترم جناب / محترمہ " + userName + "<br><br>";
                messabeBody1="آپ کا پاس ورڈ "+"<strong>" + passwordGen + "</strong>"+" یہ خود بخود تیار ہوچکا ہے۔ آل سے منسلک ایپ پر جائیں اور شروع میں ایک بار لائسنس پلیٹ اور تیار کردہ پاس ورڈ درج کریں ، " +
                            "اور لاگ ان بٹن پر کلک کریں۔ تب آپ کے پاس اپنا نیا پاس ورڈ داخل کرنے کے لئے ایک اسکرین ظاہر ہوگی ، کیوں کہ پیدا کردہ پاس ورڈ عارضی ہے۔"+"<br>"+" ایک بار پاس ورڈ کی تبدیلی کی سکرین پر ، " +
                            "اپنی پسند کے پاس ورڈ میں تبدیلی کریں اور ایک بار تبدیل ہونے کے بعد درخواست شروع کریں اور اپنے نئے پاس ورڈ کے ساتھ لاگ ان کریں۔"+"<br><br>"+"کسی بھی سوال یا سوالات کے ل support ، مدد کے ذریعہ ہم سے رابطہ کرنے میں سنکوچ نہ کریں<br><br>";
                messageFarawell="مخلص"+"<br>"+"allConnected ٹیم.";
                allMessages = messageHeader+messabeBody1+messageFarawell;
        }
        return allMessages
    }
    
    

}



 
