//
//  LoginViewController.swift
//  ParagisKitchen
//
//  Created by Noirdemort on 22/09/19.
//  Copyright © 2019 Noirdemort. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        statusBarView.backgroundColor = UIColor(red: CGFloat(0.258), green: CGFloat(0.117), blue: CGFloat(0.0), alpha: CGFloat(1.0))
        statusBarView.tintColor = .white
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        prelogin()
    }

    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func login(_ sender: Any) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        emailField.text! = emailField.text!.trim()
        passwordField.text! = passwordField.text!.trim()
        
        if (emailField.text!.isEmpty || passwordField.text!.isEmpty){
            
            let credentialsAlert = createAlert(header: Alerts.InvalidCredentialError.rawValue,
                                               message: Alerts.CredentialsMissingError.rawValue,
                                               consolation: Alerts.TryAgain.rawValue)
            
            self.present(credentialsAlert, animated: true, completion: nil)
            
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return
        }
        
        //  firebase sign in
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
            
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                print(error)
                // Invalid Credentials Alert
                let invalidCredAlert = createAlert(header: Alerts.InvalidCredentialError.rawValue,
                                                   message: Alerts.GenericErrorLong.rawValue,
                                                   consolation: Alerts.TryAgain.rawValue)
                
                self.present(invalidCredAlert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                return
            }
            
            do {
            
                let fetchRequest:NSFetchRequest<AuthDB> = AuthDB.fetchRequest()
                
                let listUser = try context.fetch(fetchRequest)
                for user in listUser {
                    context.delete(user)
                }
                
            } catch {
                
                print(error.localizedDescription)
            }
            
            let user = AuthDB(context: context)
            
            user.username = self.emailField.text!
            user.password = self.passwordField.text!
            
            db.saveContext()
            
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            self.performSegue(withIdentifier: "cuisineVC", sender: nil)
            
        }
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func prelogin(){
        let fetchRequest:NSFetchRequest<AuthDB> = AuthDB.fetchRequest()
        do {
            let listUser = try context.fetch(fetchRequest)
            if listUser.count < 1 {
                return
            }
            let user = listUser[0]
            self.emailField.text = user.username!
            self.passwordField.text = user.password!
            self.login("login" as Any)
        }catch{
            print(Alerts.DatabaseAuthDBError.rawValue)
            print(error.localizedDescription)
        }
    }
    
    
}
