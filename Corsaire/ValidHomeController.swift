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
    @IBOutlet weak var aroundMeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("app_name".localized)
        aroundMeButton.setTitle("recherche_proximite".localized, forState: .Normal)
        let departure: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.5680398, longitude: 13.3293264)
        let arrival: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.5581004,longitude: 13.3313435)
        let itineraryHelper: ItineraryHelper = ItineraryHelper()
        
        itineraryHelper.getItinerary(departure, arrival: arrival, actionOnComplete:{(itinerary) in
            print("ITINERARY STEPS \(itinerary.steps)")
        })
    }

}

