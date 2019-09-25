//
//  RecommendedRecipesViewController.swift
//  ParagisKitchen
//
//  Created by Noirdemort on 22/09/19.
//  Copyright © 2019 Noirdemort. All rights reserved.
//

import UIKit

class RecommendedRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var positions: [Any] = []
    var recipeCells: [RecipeCell] = []
    var selectedCell: RecipeCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendationTable.delegate = self
        recommendationTable.dataSource = self
        
        loadData()
    }
    
    @IBOutlet weak var recommendationTable: UITableView!
    
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData(){
        
        for recommendation in positions {
            guard let recipeDetail = recommendation as? [String: String] else { continue }
            let cell = recommendationTable.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
            cell.cellImage.downloaded(from: recipeDetail["image"]!)
            cell.cellTitle.text = recipeDetail["name"]
            cell.foodDescription = recipeDetail["des"]
            cell.ingredients = recipeDetail["ind"]
            cell.externalLink = recipeDetail["link"]
            recipeCells.append(cell)
        }
        recommendationTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = recipeCells[indexPath.row]
        self.performSegue(withIdentifier: "recipeVC", sender: "internal")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return recipeCells[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender as? String == "internal" {
            let recipeVC = segue.destination as! RecipeViewController
            recipeVC.foodDescription = selectedCell!.foodDescription
            recipeVC.ingredients = selectedCell!.ingredients
            recipeVC.externalLink = selectedCell!.externalLink
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellTitle: UILabel!
    
    var foodDescription: String!
    
    var ingredients: String!
    
    var externalLink: String!
    
}
