//
//  AroundMeController.swift
//  Corsaire
//
//  Created by Elie on 19/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AroundMeController: UITableViewController {
    private var categories: [String: (String,[String])] = [String: (String,[String])]()
    var userLocation: CLLocation? = nil
    var sortedCategorieKeys: [String]? = nil
    var chosenLocations: [Place]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCategories()
        self.chosenLocations = nil
        self.title = "liste_categories".localized
        
        let settings: UIButton = UIButton(frame: CGRectMake(0, 0, 50, 50))
        settings.setImage(UIImage(named: "settings"), forState: .Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settings)        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.keys.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "aroundMeCell"
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        var categorieKeysWithoutOthers: [String] = Array(self.categories.keys).filter({(key) in
                return key != "autre".localized
        }).sort()
        categorieKeysWithoutOthers.append("autre".localized)
        self.sortedCategorieKeys = categorieKeysWithoutOthers
        let key: String = categorieKeysWithoutOthers[indexPath.item]
        cell.textLabel?.text = key
        cell.imageView?.image = UIImage(named: self.categories[key]!.0)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //calculer les points autour
        //perform segue
        if let categorieKeys = self.sortedCategorieKeys, userLoc = self.userLocation{
            PlacesHelper.getCategories(categorieKeys[indexPath.item], userLocation: userLoc, categories: self.categories, actionOnComplete: {(places) in
                print("NOMBRE DE PLACES \(places.count)")
                self.chosenLocations = places
                dispatch_async(dispatch_get_main_queue(),{
                    self.performSegueWithIdentifier("locationsSegue", sender: self)
                })
            })
        }else{
            print("REQUIRED PARAMETER MISSING")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "locationsSegue"){
            if let locations = self.chosenLocations, userLoc = self.userLocation{
                let svc = segue.destinationViewController as! LocationsController
                svc.locations = locations
                svc.userLocation = userLoc
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(identifier == "locationsSegue" && chosenLocations == nil){
            return false;
        }
        return true;
    }
    
    private func initCategories() {
        self.categories["bar".localized] = ("bar",["bar"])
        self.categories["boulangerie".localized] = ("boulangerie",["bakery"])
        self.categories["bijouterie".localized] = ("bijouterie",["jewelry_store"])
        self.categories["coiffeur".localized] = ("coiffeur",["hair_care"])
        self.categories["culture".localized] = ("culture",["library","museum"])
        self.categories["atm".localized] = ("atm",["atm"])
        self.categories["pharmacie".localized] = ("pharmacie",["pharmacy"])
        self.categories["restaurant".localized] = ("restaurant",["restaurant"])
        self.categories["supermarche".localized] = ("supermarche",["grocery_or_supermarket"])
        self.categories["transport".localized] = ("transport",["subway_station","bus_station","train_station"])
        self.categories["shopping".localized] = ("shopping",["shoe_store","clothing_store"])
        self.categories["autre".localized] = ("autre",["amusement_park","aquarium","book_store","art_gallery","casino","cemetery","gym","mosque","pet_store","hindu_temple","synagogue"])
    }
}