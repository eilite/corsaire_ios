//
//  ItineraryHelper.swift
//  Corsaire
//
//  Created by Elie on 14/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import MapKit
// APIkey : AIzaSyCBSBccUNuVsDo59ISe2AHEd9wfc9SDHCc
class ItineraryHelper {
    let BASEURL : String = "https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyCBSBccUNuVsDo59ISe2AHEd9wfc9SDHCc&mode=transit"
    
    func getItinerary(departure: CLLocationCoordinate2D, arrival: CLLocationCoordinate2D/*,map: MKMapView, */,actionOnComplete: ((NSData?, NSURLResponse?, NSError?)->Void)?){
        //origin=Chicago,IL&destination=Los+Angeles,CA&waypoints=Joplin,MO|Oklahoma+City,OK&
        var jsonItinerary: [String: AnyObject]? = nil
        let httpRequest: HttpRequest = HttpRequest(endpoint: "\(BASEURL)&origin=\(departure.latitude),\(departure.longitude)&destination=\(arrival.latitude),\(arrival.longitude)")
        do{
            try httpRequest.get(actionOnComplete)
        }catch{
            print(error)
        }
        
    }
    /*func drawItinerary(endpoint: String, from_lat: Double, from_lng: Double, to_lat: Double, to_lng: Double, map: MKMapView, mentalView: Bool, actionOnComplete: (([String: AnyObject])->Void)?) {
        var jsonItinerary: [String: AnyObject]? = nil
        let httpRequest: HttpRequest = HttpRequest(endpoint: endpoint)
        let json: NSDictionary = ["from_lat":from_lat, "from_lng": from_lng, "to_lat": to_lat, "to_lng": to_lng]
        dispatch_async(dispatch_get_main_queue()){
            map.removeOverlays(map.overlays)
        }
        do {
            try httpRequest.post(json, headers: ["Content-Type":"application/json","Accept":"application/json"],actionOnComplete: {(data, response, error) in
                if error != nil {
                    JLToast.makeText(self.erreurCalculItineraire).show()
                    print("error=\(error)")
                } else {
                    do {
                        jsonItinerary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                        if let itinerary = jsonItinerary, route = itinerary["route"] as? [String: AnyObject], shape = route["shape"] as? [String: AnyObject], shapePoints = shape["shapePoints"] as? [Double] {
                            var pointsArray: [CLLocationCoordinate2D] = []
                            for i in 0..<(shapePoints.count) {
                                if(i%2==0) {
                                    pointsArray.append(CLLocationCoordinate2D(latitude: shapePoints[i], longitude: shapePoints[i+1]))
                                }
                            }
                            let polyline = MKPolyline(coordinates: &pointsArray, count: (shapePoints.count/2))
                            dispatch_async(dispatch_get_main_queue(), {
                                if(mentalView){
                                    let overlay = MentalTileOverlay()
                                    overlay.canReplaceMapContent = true
                                    map.addOverlays([overlay,polyline])
                                }else{
                                    map.addOverlay(polyline)
                                }
                                if let action = actionOnComplete{
                                    action(itinerary)
                                }
                            })
                        }else{
                            JLToast.makeText(self.erreurCalculItineraire).show()
                        }
                    } catch {
                        print(error)
                        JLToast.makeText(self.erreurCalculItineraire).show()
                    }
                }
            })
        } catch {
            print(error)
        }
    }*/

}