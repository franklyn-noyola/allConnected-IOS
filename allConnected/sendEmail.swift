//
//  sendEmail.swift
//  allConnected
//
//  Created by Franklyn Garcia Noyola on 7/5/21.
//

import UIKit

class sendEmail: UIViewController {

    func sendEmail(usertoSend : String, recipient : String, subject : String, message : String, fromName : String){
        let mailSession = MCOSMTPSession()
        mailSession.hostname = "smtp.ionos.es"
        mailSession.username = "allconnected@epicdevelopers.es"
        mailSession.password = "Drcr1989@"
        mailSession.port = 587
        mailSession.authType = MCOAuthType.saslPlain
        mailSession.connectionType = MCOConnectionType.startTLS
        mailSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        let mailBuilder = MCOMessageBuilder()
        mailBuilder.header.to = [MCOAddress(displayName: usertoSend, mailbox: recipient) as Any]
        mailBuilder.header.from = MCOAddress(displayName: fromName, mailbox: "allconnected@epicdevelopers.es")
        mailBuilder.header.subject = subject
        mailBuilder.htmlBody = message
        
        let mailSent = mailBuilder.data()
        let sentMail = mailSession.sendOperation(with: mailSent)
        sentMail?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(error)")
            }else{
                NSLog("Email sent successfully")
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
