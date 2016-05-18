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
    var BASEURL : String = "https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyCBSBccUNuVsDo59ISe2AHEd9wfc9SDHCc"
    
    init(){
        registerSettingsBundle()
        //settings
        let defaults = NSUserDefaults.standardUserDefaults()
        let transit = defaults.boolForKey("transit_preference")
        if(transit){
            BASEURL = "\(BASEURL)&mode=transit"
        }else{
            BASEURL = "\(BASEURL)&mode=walking"
        }
    }
    
    func getItinerary(departure: CLLocationCoordinate2D, arrival: CLLocationCoordinate2D/*,map: MKMapView, */,actionOnComplete: ((Itinerary)->Void)?){
        //origin=Chicago,IL&destination=Los+Angeles,CA&waypoints=Joplin,MO|Oklahoma+City,OK&
        var jsonItinerary: [String: AnyObject]? = nil
        let httpRequest: HttpRequest = HttpRequest(endpoint: "\(BASEURL)&origin=\(departure.latitude),\(departure.longitude)&destination=\(arrival.latitude),\(arrival.longitude)")
        do{
            try httpRequest.get({(data,response,error) in
                if error != nil {
                    print("ERROR \(error)")
                    return
                }
                do{
                    jsonItinerary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                    if let routes = jsonItinerary!["routes"] as? [[String: AnyObject]],legs = routes[0]["legs"] as? [[String: AnyObject]],  destination = legs[0]["end_address"] as? String, startAddress = legs[0]["start_address"] as? String, distanceObj = legs[0]["distance"] as? [String: AnyObject], distance = distanceObj["value"] as? Int, distanceText = distanceObj["text"] as? String, durationObj = legs[0]["duration"] as? [String: AnyObject], durationText = durationObj["text"] as? String, duration = durationObj["value"] as? Int, steps = legs[0]["steps"] as? [[String: AnyObject]], overview_polyline = routes[0]["overview_polyline"] as? [String: String], polyline = overview_polyline["points"]
                    {
                        
                        let itinerary: Itinerary = Itinerary(startAddress: startAddress, destination: destination, time: duration, distance: distance, steps: self.getSteps(steps), polyline: polyline, tempsText: durationText, distanceText: distanceText, name: "itinerary")
                        if let action = actionOnComplete{
                            action(itinerary)
                        }
                        
                    }
                    
                    
                }catch{
                    print(error)
                }
                
            })
        }catch{
            print(error)
        }
        
    }
    
    func getSteps(json: [[String: AnyObject]])-> [Step]{
        var steps: [Step] = []
        for step in json {
            if let travelMode = step["travel_mode"] as? String{
                print("TRAVELMODE \(travelMode)")
                if(travelMode == ("WALKING")){
                    if let subSteps = step["steps"] as? [[String: AnyObject]]{
                        for substep in subSteps{
                            var substepcopy = substep
                            if (substep["html_instructions"] == nil){
                                substepcopy["html_instructions"] = step["html_instructions"] as! String
                            }
                            
                            if let startLocation = substepcopy["start_location"] as? [String: AnyObject], startlng = startLocation["lng"] as? Double, startlat = startLocation["lat"] as? Double, endLocation = substepcopy["end_location"] as? [String: AnyObject], endlng = endLocation["lng"] as? Double, endlat = endLocation["lat"] as? Double, narrative = substepcopy["html_instructions"] as? String, polyline = substepcopy["polyline"] as? [String: AnyObject], points = polyline["points"] as? String{
                                var maneuver: String = ""
                                let poly: Polyline = Polyline(encodedPolyline: points)
                                if let manvr = substepcopy["maneuver"] as? String{
                                    maneuver = manvr
                                }
                                
                                steps.append(WalkingStep(maneuver: maneuver, start: CLLocationCoordinate2D(latitude: startlat, longitude: startlng), end: CLLocationCoordinate2D(latitude: endlat, longitude: endlng), narrative: narrative, polyline: poly.locations!))
                            }
                        }
                    }else{
                        if let startLocation = step["start_location"] as? [String: AnyObject], startlng = startLocation["lng"] as? Double, startlat = startLocation["lat"] as? Double, endLocation = step["end_location"] as? [String: AnyObject], endlng = endLocation["lng"] as? Double, endlat = endLocation["lat"] as? Double, narrative = step["html_instructions"] as? String, polyline = step["polyline"] as? [String: AnyObject], points = polyline["points"] as? String{
                            var maneuver: String = ""
                            let poly: Polyline = Polyline(encodedPolyline: points)
                            if let manvr = step["maneuver"] as? String{
                                maneuver = manvr
                            }
                            
                            steps.append(WalkingStep(maneuver: maneuver, start: CLLocationCoordinate2D(latitude: startlat, longitude: startlng), end: CLLocationCoordinate2D(latitude: endlat, longitude: endlng), narrative: narrative, polyline: poly.locations!))
                        }
                    }
                    
                }else if(travelMode == "TRANSIT"){
                    if let startLocation = step["start_location"] as? [String: AnyObject], startlng = startLocation["lng"] as? Double, startlat = startLocation["lat"] as? Double, endLocation = step["end_location"] as? [String: AnyObject], endlng = endLocation["lng"] as? Double, endlat = endLocation["lat"] as? Double, narrative = step["html_instructions"] as? String, polyline = step["polyline"] as? [String: AnyObject], points = polyline["points"] as? String, transitDetails = step["transit_details"] as? [String: AnyObject], departureStop = transitDetails["departure_stop"] as? [String: AnyObject], arrivalStop = transitDetails["arrival_stop"] as? [String: AnyObject], departureStopName = departureStop["name"] as? String, arrivalStopName = arrivalStop["name"] as? String, departureTime = transitDetails["departure_time"] as? [String: AnyObject], departureTimeText = departureTime["text"] as? String
                    {
                        var maneuver: String = ""
                        let poly: Polyline = Polyline(encodedPolyline: points)
                        if let manvr = step["maneuver"] as? String{
                            maneuver = manvr
                        }
                        var shortname: String = ""
                        if let line = transitDetails["line"] as? [String: AnyObject], srtnm = line["short_name"] as? String{
                            shortname = "(\(srtnm))"
                        }
                        let nrtv = "\("prendre_le".localized) \(narrative) \(shortname) \("de_larret".localized) \(departureStopName) \("jusqua_larret".localized) \(arrivalStopName)"
                        
                        steps.append(TransitStep(maneuver: maneuver, start: CLLocationCoordinate2D(latitude: startlat, longitude: startlng), end: CLLocationCoordinate2D(latitude: endlat, longitude: endlng), narrative: nrtv, polyline: poly.locations!, departureTime: departureTimeText))
                        }
                }
                
                
            }
        }
        
        return steps
    }
    
    private func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
        //NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    

}