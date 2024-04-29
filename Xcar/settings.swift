//
//  settingsViewController.swift
//  allConnected
//
//  Created by Franklyn Garica Noyola on 25/5/21.
//

import UIKit
import Firebase

class settings: UIViewController {
    var buttons = [UIButton]()
    var noLanguageSelected : String!
    var userLanguageSelected : String!
    var spanishLan : String!
    var englishLan : String!
    var frenchLan : String!
    var germanLan : String!
    var italianLan : String!
    var portugueseLan : String!
    var russianLan : String!
    var chineseLan : String!
    var japaneseLan : String!
    var dutchLan : String!
    var polishLan : String!
    var userRef : DatabaseReference!
    var languageUpdated : String!
    var koreanLan : String!
    var swedishLan : String!
    var arabicLan : String!
    var urduLan : String!
    var hindiLan : String!
    var selectLang : String!
    var languagechangeheader : String!
    var cancel : String!
    var warningLanguage : String!
    var updateLanguage : String!
    var getbuttonIndex : Int = -1
    var mToken : String!
    
    @IBOutlet weak var selectLanguageField: UILabel!
    @IBOutlet weak var spanishButton: UIButton!
    @IBOutlet weak var spanishField: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var englishField: UILabel!
    @IBOutlet weak var frenchButton: UIButton!
    @IBOutlet weak var frenchField: UILabel!
    @IBOutlet weak var germanField: UILabel!
    @IBOutlet weak var germanButton: UIButton!
    @IBOutlet weak var italianButton: UIButton!
    @IBOutlet weak var italianField: UILabel!
    @IBOutlet weak var portugueseButton: UIButton!
 
    @IBOutlet weak var portugueseField: UILabel!
    @IBOutlet weak var russianButton: UIButton!
   
    @IBOutlet weak var russianField: UILabel!
    @IBOutlet weak var chineseButton: UIButton!
    @IBOutlet weak var chineseField: UILabel!
    @IBOutlet weak var japaneseField: UILabel!
    @IBOutlet weak var japaneseButton: UIButton!
    @IBOutlet weak var dutchField: UILabel!
    @IBOutlet weak var dutchButton: UIButton!
    @IBOutlet weak var polishButton: UIButton!
    @IBOutlet weak var polishField: UILabel!
    @IBOutlet weak var koreanButton: UIButton!
    @IBOutlet weak var koreanField: UILabel!
    @IBOutlet weak var swedishButton: UIButton!
   @IBOutlet weak var swedishField: UILabel!
    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var arabicField: UILabel!
    @IBOutlet weak var urduButton: UIButton!
    @IBOutlet weak var urduField: UILabel!
        @IBOutlet weak var hindiButton: UIButton!
    @IBOutlet weak var hindiField: UILabel!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changeLangButton: UIButton!
    
    @IBOutlet weak var warningField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        userRef = Database.database().reference()
        changeLanguage()
        configFields()
        title = languagechangeheader
        getCurrentLanguage()
        setFieldsDisable()
        getButtonsSelected()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configFields() {
        spanishField.text = spanishLan
        englishField.text = englishLan
        frenchField.text = frenchLan
        germanField.text = germanLan
        italianField.text = italianLan
        portugueseField.text = portugueseLan
        russianField.text = russianLan
        chineseField.text = chineseLan
        japaneseField.text = japaneseLan
        dutchField.text = dutchLan
        polishField.text = polishLan
        koreanField.text = koreanLan
        swedishField.text = swedishLan
        arabicField.text = arabicLan
        urduField.text = urduLan
        hindiField.text = hindiLan
        warningField.text = warningLanguage
        selectLanguageField.text = selectLang
        changeLangButton.setTitle(languagechangeheader, for: UIControl.State.normal)
        cancelButton.setTitle(cancel, for: UIControl.State.normal)
        changeLangButton.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
    }
    
    func setFieldsDisable() {
        changeLangButton.setTitle(languagechangeheader, for: UIControl.State.normal)
        cancelButton.isHidden = true
        warningField.isHidden = true
        spanishButton.isEnabled = false
        englishButton.isEnabled = false
        frenchButton.isEnabled = false
        germanButton.isEnabled = false
        italianButton.isEnabled = false
        portugueseButton.isEnabled = false
        russianButton.isEnabled = false
        chineseButton.isEnabled = false
        japaneseButton.isEnabled = false
        dutchButton.isEnabled = false
        polishButton.isEnabled = false
        koreanButton.isEnabled = false
        swedishButton.isEnabled = false
        arabicButton.isEnabled = false
        urduButton.isEnabled = false
        hindiButton.isEnabled = false
    }
    
    func setFieldsEnabled() {
        cancelButton.isHidden = false
        warningField.isHidden = false
        spanishButton.isEnabled = true
        englishButton.isEnabled = true
        frenchButton.isEnabled = true
        germanButton.isEnabled = true
        italianButton.isEnabled = true
        portugueseButton.isEnabled = true
        russianButton.isEnabled = true
        chineseButton.isEnabled = true
        japaneseButton.isEnabled = true
        dutchButton.isEnabled = true
        polishButton.isEnabled = true
        koreanButton.isEnabled = true
        swedishButton.isEnabled = true
        arabicButton.isEnabled = true
        urduButton.isEnabled = true
        hindiButton.isEnabled = true
    }
    
    
    private func getButtonsSelected() {
        
        spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal	)
        spanishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        spanishButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(spanishButton)
        englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        englishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        englishButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(englishButton)
        frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        frenchButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        frenchButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(frenchButton)
        germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        germanButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        germanButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(germanButton)
        italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        italianButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        italianButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(italianButton)
        portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        portugueseButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        portugueseButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(portugueseButton)
        russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        russianButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        russianButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(russianButton)
        chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        chineseButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        chineseButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(chineseButton)
        japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        japaneseButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        japaneseButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(japaneseButton)
        dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        dutchButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        dutchButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(dutchButton)
        polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        polishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        polishButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(polishButton)
        koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        koreanButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        koreanButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(koreanButton)
        swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        swedishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        swedishButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(swedishButton)
        arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        arabicButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        arabicButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(arabicButton)
        urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        urduButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected    )
        urduButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(urduButton)
        hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal    )
        hindiButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
        hindiButton.addTarget(self, action: #selector(getAction), for: UIControl.Event.touchUpInside)
        buttons.append(hindiButton)
    }
    
    @objc func getAction(sender: UIButton!) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        getbuttonIndex = buttons.firstIndex(of: sender)!
        
        switch (getbuttonIndex) {
            case 0  :       userLanguageSelected = "ES"
                            break
            case 1  :       userLanguageSelected = "EN"
                            break
            case 2  :       userLanguageSelected = "FR"
                            break
            case 3  :       userLanguageSelected = "DE"
                            break
            case 4  :       userLanguageSelected = "IT"
                            break
            case 5  :       userLanguageSelected = "PT"
                            break
            case 6  :       userLanguageSelected = "RU"
                            break
            case 7  :       userLanguageSelected = "ZH"
                            break
            case 8  :       userLanguageSelected = "JA"
                            break
            case 9  :       userLanguageSelected = "NL"
                            break
            case 10  :      userLanguageSelected = "PL"
                            break
            case 11  :      userLanguageSelected = "KO"
                            break
            case 12  :      userLanguageSelected = "SV"
                            break
            case 13  :      userLanguageSelected = "AR"
                            break
            case 14  :      userLanguageSelected = "UR"
                            break
            case 15  :      userLanguageSelected = "HI"
                            break
        default : break
        }
        
        
    }
    
    func getCurrentLanguage() {
        
        switch (userLanguageSelected.uppercased()) {
        case "ES" : spanishButton.isEnabled = false
                    spanishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
            
        case "EN" : englishButton.isEnabled = false
                    englishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "FR" : frenchButton.isEnabled = false
                    frenchButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "DE" : germanButton.isEnabled = false
                    germanButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "IT" : italianButton.isEnabled = false
                    italianButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "PT" : portugueseButton.isEnabled = false
                    portugueseButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "RU" : russianButton.isEnabled = false
                    russianButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "ZH" : chineseButton.isEnabled = false
                    chineseButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "PL" : polishButton.isEnabled = false
                    polishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "JA" : japaneseButton.isEnabled = false
                    japaneseButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "NL" : dutchButton.isEnabled = false
                    dutchButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "KO" : koreanButton.isEnabled = false
                    koreanButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "SV" : swedishButton.isEnabled = false
                    swedishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "AR" : arabicButton.isEnabled = false
                    arabicButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "UR" : urduButton.isEnabled = false
                    urduButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        case "HI" : hindiButton.isEnabled = false
                    hindiButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.disabled)
                    break
        default : break
        }
    }
    
    private func getFieldsDisable() {
        switch (userLanguageSelected.uppercased()) {
        case "ES" : spanishButton.isSelected = true
                    spanishButton.isEnabled = true
                    spanishButton.setImage(UIImage(systemName:                      "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
            
        case "EN" : englishButton.isSelected = true
                    englishButton.isEnabled = true
                    englishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "FR" : frenchButton.isSelected = true
                    frenchButton.isEnabled = true
                    frenchButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "DE" : germanButton.isEnabled = true
                    germanButton.isSelected = true
                    germanButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "IT" : italianButton.isEnabled = true
                    italianButton.isSelected = true
                    italianButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "PT" : portugueseButton.isEnabled = true
                    portugueseButton.isSelected = true
                    portugueseButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "RU" : russianButton.isEnabled = true
                    russianButton.isSelected = true
                    russianButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "ZH" : chineseButton.isEnabled = true
                    chineseButton.isSelected = true
                    chineseButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "PL" : polishButton.isEnabled = true
                    polishButton.isSelected = true
                    polishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "JA" : japaneseButton.isEnabled = true
                    japaneseButton.isSelected = true
                    japaneseButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "NL" : dutchButton.isEnabled = true
                    dutchButton.isSelected = true
                    dutchButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "KO" : koreanButton.isEnabled = true
                    koreanButton.isSelected = true
                    koreanButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "SV" : swedishButton.isEnabled = true
                    swedishButton.isSelected = true
                    swedishButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "AR" : arabicButton.isEnabled = true
                    arabicButton.isSelected = true
                    arabicButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"),   for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "UR" : urduButton.isEnabled = true
                    urduButton.isSelected = true
                    urduButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                    englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    hindiButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        case "HI" : hindiButton.isEnabled = true
                    hindiButton.isSelected = true
                    hindiButton.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: UIControl.State.selected)
                        englishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    frenchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    germanButton.setImage(UIImage(systemName: "circle"), for:   UIControl.State.disabled)
                    italianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    portugueseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    russianButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    chineseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    japaneseButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    dutchButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    polishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    koreanButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    swedishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    arabicButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    urduButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    spanishButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.disabled)
                    break
        default : break
        }
    
    }
    
    @IBAction func changeLangAction(_ sender: Any) {
        
        if (changeLangButton.currentTitle == languagechangeheader) {
            setFieldsEnabled()
            getButtonsSelected()
            changeLangButton.setTitle(updateLanguage, for: UIControl.State.normal)
            return
        }
        if (changeLangButton.currentTitle == updateLanguage){
            if (getbuttonIndex < 0) {
            showToast(message: noLanguageSelected, font: .systemFont(ofSize: 12.0))
            return
        }
            setFieldsDisable()
            getFieldsDisable()
            setLanguage()
            showToast(message: languageUpdated, font: .systemFont(ofSize: 12.0))
            return
    }
}
    
    private func setLanguage() {
        let updateLang = userRef.child("Users").child("userLanguage")
        let langQuery = updateLang.queryOrdered(byChild: "users").queryEqual(toValue: mToken)
        langQuery.observeSingleEvent(of: .value, with: {(snapshot) in
            var key : String = ""
            if (snapshot.exists()) {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    key = snap.key
                }
                self.userRef.child("Users").child("userLanguage").child(key).updateChildValues(["language": self.userLanguageSelected])
            }else{
                self.userRef.child("Users").child("userLanguage").childByAutoId().setValue(["language":  self.userLanguageSelected, "users": self.mToken])
            }
        })
    }
    @IBAction func cancelActionLang(_ sender: Any) {
        getButtonsSelected()
        setFieldsDisable()
        getFieldsDisable()
    
        
    }
    
    private func changeLanguage() {
    
        var languages = languageTranslation().englishLanguage
              
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
        
        spanishLan = languages["spanishLan"]!
        englishLan = languages["englishLan"]!
        frenchLan = languages["frenchLan"]!
        germanLan = languages["germanLan"]!
        italianLan = languages["italianLan"]!
        portugueseLan = languages["portugueseLan"]!
        russianLan = languages["russianLan"]!
        chineseLan = languages["chineseLan"]!
        japaneseLan = languages["japanLan"]!
        dutchLan = languages["dutchLan"]!
        polishLan = languages["polishLan"]!
        swedishLan = languages["swedishLan"]!
        koreanLan = languages["koreanLan"]!
        arabicLan = languages["arabicLan"]!
        urduLan = languages["urduLan"]!
        hindiLan = languages["hindiLan"]!
        selectLang = languages["selectLanguage"]!
        languagechangeheader = languages["changeLanguage"]!
        cancel = languages["cancel"]!
        warningLanguage = languages["warningLanguage"]!
        updateLanguage = languages["updateLanguage"]!
        noLanguageSelected = languages["noLanguageSelected"]!
        languageUpdated = languages["languageUpdated"]!
    }
}
