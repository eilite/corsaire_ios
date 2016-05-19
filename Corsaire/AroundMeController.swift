//
//  AroundMeController.swift
//  Corsaire
//
//  Created by Elie on 19/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import UIKit

class AroundMeController: UITableViewController {
    private var categories: [String: [String]] = [String: [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCategories()
        navigationController?.navigationBar.barTintColor = UIColor.greenColor()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.keys.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "categoriesCell"
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AroundMeCell
        var categorieKeysWithoutOthers: [String] = Array(self.categories.keys).filter({(key) in
                return key != "autre".localized
        }).sort()
        categorieKeysWithoutOthers.append("autre".localized)
        cell.AroundMeCellLabel.text = categorieKeysWithoutOthers[indexPath.item]
        return cell
    }
    
    private func initCategories() {
        self.categories["bar".localized] = ["bar"]
        self.categories["boulangerie".localized] = ["bakery"]
        self.categories["bijouterie".localized] = ["jewelry_store"]
        self.categories["coiffeur".localized] = ["hair_care"]
        self.categories["culture".localized] = ["library","museum"]
        self.categories["atm".localized] = ["atm"]
        self.categories["pharmacie".localized] = ["pharmacy","museum"]
        self.categories["restaurant".localized] = ["restaurant"]
        self.categories["supermarche".localized] = ["grocery_or_supermarket"]
        self.categories["transport".localized] = ["subway_station","bus_station","train_station"]
        self.categories["shopping".localized] = ["shoe_store","clothing_store"]
        self.categories["autre".localized] = ["amusement_park","aquarium","book_store","art_gallery","casino","cemetery","gym","mosque","pet_store","hindu_temple","synagogue"]
//    images = new HashMap<String, Integer>(){
//    {
//    put(getString(R.string.autre),R.drawable.publicc);
//    put(getString(R.string.bar),R.drawable.bar);
//    put(getString(R.string.bijouterie),R.drawable.necklace);
//    put(getString(R.string.boulangerie),R.drawable.bread);
//    put(getString(R.string.coiffeur),R.drawable.barberchair);
//    put(getString(R.string.culture),R.drawable.lyre);
//    put(getString(R.string.atm),R.drawable.bankcards);
//    put(getString(R.string.pharmacie),R.drawable.doctorsbag);
//    put(getString(R.string.restaurant),R.drawable.restaurant);
//    put(getString(R.string.shopping),R.drawable.europricetag);
//    put(getString(R.string.supermarche),R.drawable.shoppingcart);
//    put(getString(R.string.transport),R.drawable.shuttle);
//    }
    }
}