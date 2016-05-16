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
    @IBOutlet weak var arrivalView: UIView!
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var arrivalLocation: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        print("app_name".localized)
        aroundMeButton.setTitle("recherche_proximite".localized, forState: .Normal)
        
        //location search bar
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTableArrival") as! LocationSearchTableArrival
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapArrivalSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBarArrival = resultSearchController!.searchBar
        searchBarArrival.sizeToFit()
        searchBarArrival.placeholder = "destination_hint".localized
        searchBarArrival.barTintColor = UIColor.greenColor()
        searchBarArrival.tintColor = UIColor.lightGrayColor()
        searchBarArrival.layer.borderWidth = 1
        searchBarArrival.layer.borderColor = UIColor.blueColor().CGColor
        
        arrivalView.addSubview(searchBarArrival)
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        //itinerary calculation
        let departure: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.5680398, longitude: 13.3293264)
        let arrival: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.5581004,longitude: 13.3313435)
        let itineraryHelper: ItineraryHelper = ItineraryHelper(transit: false)
        
        itineraryHelper.getItinerary(departure, arrival: arrival, actionOnComplete:{(itinerary) in
            print("ITINERARY STEPS \(itinerary.steps)")
        })
    }

}

extension ValidHomeController: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

extension ValidHomeController: HandleMapSearchArrival {
    func dropArrivalPinZoomIn(placemark:MKPlacemark){
        //remove previous pin
        self.mapView.removeAnnotations(self.mapView.annotations)
        //Save new arrival
        arrivalLocation = placemark.location!.coordinate
        //And update the searchbar text
        let address = (placemark.subThoroughfare ?? "") + " " + (placemark.thoroughfare ?? "") + ", " +
            (placemark.locality ?? "") + ", " + (placemark.country ?? "")
        resultSearchController!.searchBar.text = address
        
        //Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = "Arrivée: " + placemark.name!
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        self.mapView.addAnnotation(annotation)
        
        //Fetch and draw itinerary
//        self.drawCurrentItinerary()
    }
}

