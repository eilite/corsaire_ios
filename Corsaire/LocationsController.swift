//
//  LocationsController.swift
//  Corsaire
//
//  Created by Elie on 21/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import UIKit

class LocationsController: UITableViewController{
    var locations: [Place]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Locations"
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
}