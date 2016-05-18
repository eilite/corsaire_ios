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
        
        self.mapView.delegate = self
        
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
    }
    
    func fetchAndDrawItinerary(){
        if let departure = self.userLocation, arrival = self.arrivalLocation {
            itineraryHelper.getItinerary(departure.coordinate, arrival: arrival.coordinate, actionOnComplete:{(itinerary) in
                //draw itinerary on map
                var polylinePoints: [CLLocationCoordinate2D] = []
                for step in itinerary.steps{
                    let points: [CLLocationCoordinate2D] = step.polyline.map({(point)->CLLocationCoordinate2D in
                        print("POINTS DE POLYLINE\(point.coordinate)")
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

}

extension ValidHomeController: CLLocationManagerDelegate{
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.userLocation = location
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
            print("ARRIVEE \(annotation.coordinate)")
        }
        self.mapView.addAnnotation(annotation)
        
        //Fetch and draw itinerary
        self.fetchAndDrawItinerary()
    }
}

extension ValidHomeController: MKMapViewDelegate{
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = Colors.middleBlue
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        else
        {
            return MKOverlayRenderer()
        }
    }

}

