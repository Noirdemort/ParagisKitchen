//
//  RegisterViewController.swift
//  ParagisKitchen
//
//  Created by Noirdemort on 22/09/19.
//  Copyright © 2019 Noirdemort. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class RegisterViewController: UIViewController {

    var ref: DatabaseReference!
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    
    
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBOutlet weak var emailField: UITextField!
  
    
    @IBOutlet weak var numberField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func registerNow(_ sender: Any) {
        
        let username = emailField.text!.trim()
        let pass = passwordField.text!.trim()
        nameField.text! = nameField.text!.trim()
        numberField.text! = numberField.text!.trim()
        
        
        if nameField.text!.isEmpty {
            
            let nullAlert = createAlert(header: Alerts.InputError.rawValue,
                                        message: Alerts.NameMissingError.rawValue,
                                        consolation: Alerts.OK.rawValue)
            
            self.present(nullAlert, animated: true, completion: nil)
            return
        }
        
        if (numberField.text!.count != StandardDefinitions.MobileNumberLength.rawValue){
            
            let syntaxAlert = createAlert(header: Alerts.InputError.rawValue,
                                          message: Alerts.MobileMissingError.rawValue,
                                          consolation: Alerts.OK.rawValue)
            
            self.present(syntaxAlert, animated: true, completion: nil)
            return
        }
        
        if (username.isEmpty || pass.isEmpty) {
            
            let nullAlert = createAlert(header: Alerts.InputError.rawValue,
                                        message: Alerts.EmailAndPasswordError.rawValue,
                                        consolation: Alerts.OK.rawValue)
            
            self.present(nullAlert, animated: true, completion: nil)
            return
        }
        
        if (pass.count <= StandardDefinitions.PasswordLength.rawValue) {
            
            let tooShortAlert = createAlert(header: Alerts.GenericError.rawValue,
                                            message: Alerts.PasswordLengthError.rawValue,
                                            consolation: Alerts.OK.rawValue)
            
            self.present(tooShortAlert, animated: true, completion: nil)
            return
        }
        
        if !(isValidEmail(testStr: username)) {
            
            let emailErr = createAlert(header: Alerts.InvalidInputError.rawValue,
                                       message: Alerts.InvalidEmail.rawValue,
                                       consolation: Alerts.OK.rawValue)
            
            self.present(emailErr, animated: true, completion: nil)
            return
        }
        
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        Auth.auth().createUser(withEmail: username, password: pass) { (authResult, error) in
            
            if let user = authResult?.user {
                self.uid = user.uid
                
                let userObject = ["id": user.uid,
                                   "useremail": username,
                                   "usernumber": self.numberField.text!,
                                   "username": self.nameField.text!,
                                   "userpassword": pass]
                
                let user =  self.ref
                    .child(FirebaseNode.UserNode.rawValue)
                    .child(self.uid)
                
                user.setValue(userObject)
                
                let userDB = AuthDB(context: context)
                
                userDB.username = username
                userDB.password = pass
                db.saveContext()
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                
                self.performSegue(withIdentifier: "cuisineVC", sender: nil)
            } else {
                print(error?.localizedDescription as Any)
                
                let signUpAlert = createAlert(
                    header: Alerts.RegistrationError.rawValue,
                    message: Alerts.SignUpProcessError.rawValue,
                    consolation: Alerts.TryAgain.rawValue
                )
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.present(signUpAlert, animated: true, completion: nil)
                return
            }
        }
    }
    
    
    // mail validity check
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = Regex.Email.rawValue
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
