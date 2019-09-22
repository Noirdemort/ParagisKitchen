//
//  CoreUtils.swift
//  ParagisKitchen
//
//  Created by Noirdemort on 22/09/19.
//  Copyright © 2019 Noirdemort. All rights reserved.
//

import Foundation
import UIKit


let cuisines = ["Baked Dishes": "bake",
                "Chinese": "noodles",
                "Chutneys & Pickles": "pickle",
                "Dal": "dal",
                "Desserts": "dessert",
                "Fast Food": "fast",
                "Indian Breads": "roti",
                "Italian": "italian",
                "Jain Food": "jain",
                "Rice Items": "rice",
                "Sabzi (Dry)":"dry",
                "Sabzi (With Gravy)":"gravy",
                "Snacks & Breakfast": "snacks",
                "Starters & Soups": "strter"]

enum Regex: String {
    case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
}

enum StandardDefinitions: Int{
    case PasswordLength = 7
    case MobileNumberLength = 10
}

enum FirebaseNode: String{
    case Org = "orgCode"
    case UserNode = "Users"
    case ApplicationStatus = "applicationStatus"
    case FirebaseToken = "FirebaseToken"
    case Step0 = "Step0Object"
    case Step1 = "Step1Object"
    case Step2 = "Step2Object"
    case Step3 = "Step3Object"
    case Timestamp = "createdTimestamp"
    case Devices = "Devices"
    case Files = "files"
    case Validation = "validation"
}

enum Alerts: String{
    // Error
    case GenericError = "Error!"
    case GenericErrorLong = "Some Error Occured!"
    case InputError = "Input Error"
    case TokenError = "Token Error"
    case InvalidInputError = "Invalid input"
    case InvalidEmail = "Invalid Email!!"
    case ImageUploadError = "Image Upload Error"
    
    case InvalidCredentialError = "Invalid Credentials!"
    case RegistrationError = "Registration Error"
    case IncompleteDetailsError = "Incomplete Details"
    
    case PasswordLengthError = "Password length too short."
    case PasswordResetSent = "Password reset link sent to your email!"
    
    case SignUpProcessError = "Sign Up Process failed!"
    case SignOutError = "Sign out unsuccessful! Please try again."
    case UploadError = "Some error occured while uploading"
    
    case DetailsMissingError = "Please enter all details"
    case CredentialsMissingError = "All credentials are required."
    case NameMissingError = "Name is Missing."
    case MobileMissingError = "Mobile phone is required."
    case MobileNumberError = "10 Digit Mobile Number is required."
    case EmailAndPasswordError = "Email and password are neccessary."

    case DatabaseAuthDBError = "Database error occured! AuthDB"
    
    // Completion
    case Success = "Successful!!"
    case AllStepsDone = "All steps are completed!"
    case NoError = "No Error"
    case SuccessfullUpload = "Thanks for your submission!"
    
    // Actions
    case OK = "OK"
    case Cool = "Cool!"
    case Done = "Done."
    case Retry = "Retry!"
    case TryAgain = "Try Again!"
    case UploadAgain = "Upload again!"
    
}


extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) { 
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

func createAlert(header: String, message: String, consolation: String)->UIAlertController{
    let alertController = UIAlertController(title: header, message: message, preferredStyle: .alert)
    
    //then we create a default action for the alert...
    //It is actually a button and we have given the button text style and handler
    //currently handler is nil as we are not specifying any handler
    let defaultAction = UIAlertAction(title: consolation ,style: .default, handler: nil)
    
    //now we are adding the default action to our alertcontroller
    alertController.addAction(defaultAction)
    
    return alertController
}
