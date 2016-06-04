//
//  LocationsController.swift
//  Corsaire
//
//  Created by Elie on 21/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class LocationsController: UITableViewController{
    var locations: [Place]? = nil
    var chosenLocation: Place? = nil
    var userLocation: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "liste_categories".localized
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let lcts = self.locations{
            return lcts.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "locationsCell"
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        if let lcts = self.locations{
            let location: Place = lcts[indexPath.item]
            cell.textLabel?.text = location.title
            cell.detailTextLabel?.text = "\(location.distance ?? 0) m"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let lcts = locations{
            print("chose location")
            chosenLocation = lcts[indexPath.item]
            performSegueWithIdentifier("homeSegue", sender: self)
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(identifier == "homeSegue"){
            return false
        }
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "homeSegue"){
            if let location = self.chosenLocation, userLoc = self.userLocation{
                print("SEGUE")
                let svc = segue.destinationViewController as! ValidHomeController
                svc.chosenLocation = location
                svc.userLocation = userLoc
            }
        }
    }
}