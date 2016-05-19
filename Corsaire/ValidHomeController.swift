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
    var arrivalLocation: CLLocation? = nil
    var userLocation: CLLocation? = nil
    let itineraryHelper: ItineraryHelper = ItineraryHelper()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Corsaire"
        print("NAVIGATION CONTROLLER\(self.navigationController!)")
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.greenColor()

        self.mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        print("app_name".localized)
        aroundMeButton.setTitle("recherche_proximite".localized, forState: .Normal)
        
        aroundMeButton.addTarget(self, action: #selector(aroundMeButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)

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
    }
    
    func fetchAndDrawItinerary(){
        if let departure = self.userLocation, arrival = self.arrivalLocation {
            itineraryHelper.getItinerary(departure.coordinate, arrival: arrival.coordinate, actionOnComplete:{(itinerary) in
                //draw itinerary on map
                var polylinePoints: [CLLocationCoordinate2D] = []
                for step in itinerary.steps{
                    let points: [CLLocationCoordinate2D] = step.polyline.map({(point)->CLLocationCoordinate2D in
                        return point.coordinate
                    })
                     polylinePoints.appendContentsOf(points)
                    
                }
                dispatch_async(dispatch_get_main_queue(), {
                    let polyline = MKPolyline(coordinates: &polylinePoints, count: polylinePoints.count)
                    self.mapView.addOverlay(polyline, level: .AboveLabels)
                })
                
            })
        }
        
        
    }
    
    func aroundMeButtonPressed(sender: UIButton!){
        print("BUTTON PRESSED")
        let vc = AroundMeController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ValidHomeController: HandleMapSearchArrival {
    func dropArrivalPinZoomIn(placemark:MKPlacemark){
        //remove previous pin
        self.mapView.removeAnnotations(self.mapView.annotations)
        //Save new arrival
        self.arrivalLocation = placemark.location!
        //And update the searchbar text
        let address = (placemark.subThoroughfare ?? "") + " " + (placemark.thoroughfare ?? "") + ", " +
            (placemark.locality ?? "") + ", " + (placemark.country ?? "")
        resultSearchController!.searchBar.text = address
        //set arrival location
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
        self.fetchAndDrawItinerary()
    }
}



