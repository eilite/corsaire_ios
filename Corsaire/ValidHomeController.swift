//
//  ValidHomeController.swift
//  Corsaire
//
//  Created by Elie on 14/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ValidHomeController: UIViewController{
       
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("app_name".localized)
        let departure: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.5680398, longitude: 13.3293264)
        let arrival: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.5581004,longitude: 13.3313435)
        let itineraryHelper: ItineraryHelper = ItineraryHelper()
        itineraryHelper.getItinerary(departure, arrival: arrival, actionOnComplete: {(data, response, error) in
            print(data.debugDescription)
            do {
                let jsonItinerary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                print("JSON ITINERARY \(jsonItinerary.debugDescription)")
            }catch{
                print(error)
            }
            })
    }

}

