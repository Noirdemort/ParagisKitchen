//
//  CuisineViewController.swift
//  ParagisKitchen
//
//  Created by Noirdemort on 22/09/19.
//  Copyright © 2019 Noirdemort. All rights reserved.
//

import UIKit

class CuisineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cuisineCells: [CuisineCell] = []

    var cuisineKey: [String] = []
    var cuisineValue: [String] = []
    var selectedFood: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cuisineCollection.delegate = self
        cuisineCollection.dataSource = self
        
        for cuisine in cuisines{
            cuisineKey.append(cuisine.key)
            cuisineValue.append(cuisine.value)
        }
    }
    
    
    @IBOutlet weak var cuisineCollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFood = cuisineKey[indexPath.row]
        self.performSegue(withIdentifier: "foodsVC", sender: "internal")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cuisineKey.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let image = UIImage(named: cuisineValue[indexPath.row])
        image?.accessibilityFrame.size = CGSize(width: 185, height: 220)
        
        let cuisineCell = cuisineCollection.dequeueReusableCell(withReuseIdentifier: "cellColumn1", for: indexPath) as! CuisineCell
        cuisineCell.cellImage.image = image
        cuisineCell.cellTitle.text = cuisineKey[indexPath.row]
        return cuisineCell
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender as? String == "internal" {
            let secondController = segue.destination as! FoodsViewController
            secondController.foodCategory = selectedFood!
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


class CuisineCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellTitle: UILabel!
    
}
