//
//  RecipeViewController.swift
//  ParagisKitchen
//
//  Created by Noirdemort on 22/09/19.
//  Copyright © 2019 Noirdemort. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    var foodDescription = ""
    var ingredients = ""
    var externalLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodDescriptionView.text = foodDescription
        ingredientsView.text = ingredients
    }
    
    
    @IBOutlet weak var foodDescriptionView: UITextView!
    
    
    @IBOutlet weak var ingredientsView: UITextView!
    
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func openExternalLink(_ sender: Any) {
        UIApplication.shared.open(URL(string: externalLink) ?? URL(string: "https://www.duckduckgo.com")!, options: [:], completionHandler: nil)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
