//
//  RecoverViewController.swift
//  ParagisKitchen
//
//  Created by Noirdemort on 22/09/19.
//  Copyright © 2019 Noirdemort. All rights reserved.
//

import UIKit
import Firebase

class RecoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func resetPassword(_ sender: Any) {
        emailField.text! = emailField.text!.trim()
        
        if (emailField.text!.isEmpty){
            
            let credentialsAlert = createAlert(header: Alerts.InvalidEmail.rawValue,
                                               message: Alerts.DetailsMissingError.rawValue,
                                               consolation: Alerts.TryAgain.rawValue)
            
            self.present(credentialsAlert, animated: true, completion: nil)
            
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return
        }
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        Auth.auth().sendPasswordReset(withEmail: emailField.text!, completion: { (error) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            if error != nil {
                let nodeFailureAlert = createAlert(header: Alerts.GenericError.rawValue,
                                                   message: Alerts.GenericErrorLong.rawValue,
                                                   consolation: Alerts.TryAgain.rawValue)
                
                self.present(nodeFailureAlert, animated: true, completion: nil)
                
                return
            }
            let nodeFailureAlert = createAlert(header: Alerts.Success.rawValue,
                                                   message: Alerts.PasswordResetSent.rawValue,
                                                   consolation: Alerts.OK.rawValue)
                
            self.present(nodeFailureAlert, animated: true, completion: nil)
            
        })
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
