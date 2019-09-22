//
//  FoodsViewController.swift
//  ParagisKitchen
//
//  Created by Noirdemort on 22/09/19.
//  Copyright © 2019 Noirdemort. All rights reserved.
//

import UIKit
import Firebase

class FoodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var foodCategory: String = ""
    var ref: DatabaseReference!
    
    var foodCells: [FoodCell] = []
    var allFoodCells: [FoodCell] = []

    var selectedCell: FoodCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        searchFood.delegate = self
        foodTable.delegate = self
        foodTable.dataSource = self
       
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        foodLabel.text = foodCategory
        preload()
    }
    
    
    @IBOutlet weak var searchFood: UISearchBar!
    
    
    @IBOutlet weak var foodTable: UITableView!
    
    
    @IBOutlet weak var foodLabel: UILabel!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func preload() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.ref
            .child(foodCategory)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? [Any] ?? []
                
                for food in value {
                    
                    guard let foodDetail = food as? [String: Any] else { continue }
                    
                    let cell = self.foodTable.dequeueReusableCell(withIdentifier: "foodCell") as! FoodCell
                    cell.cellTitle.text = foodDetail["name"] as? String
                    cell.positions = foodDetail["Position"] as? [Any] ?? []
                    cell.cellImage.downloaded(from: foodDetail["image"] as! String)
                    self.allFoodCells.append(cell)
                }
                self.foodCells = self.allFoodCells
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.foodTable.reloadData()
                
            }, withCancel: { (error) in
                print(error.localizedDescription)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            })
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        foodCells = []
        
        let keyword = searchText.trim().lowercased()
        
        if keyword.isEmpty {
            foodCells = allFoodCells
            print(foodCells.count)
            foodTable.reloadData()
            return
        }
        
        for cell in allFoodCells {
            if cell.cellTitle.text!.lowercased().contains(keyword){
                foodCells.append(cell)
            }
        }
        
        foodTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = foodCells[indexPath.row]
        self.performSegue(withIdentifier: "recommendedVC", sender: "internal")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodCells.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return foodCells[indexPath.row]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender as? String == "internal" {
            let recipeVC = segue.destination as! RecommendedRecipeViewController
            recipeVC.positions = selectedCell!.positions
        }
    }

}


class FoodCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellTitle: UILabel!
    
    var positions: [Any]!
}
