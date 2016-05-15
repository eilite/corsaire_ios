//
//  Steps.swift
//  Corsaire
//
//  Created by Elie on 15/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import MapKit

class Step {
    var maneuver: String
    var start: CLLocationCoordinate2D
    var end: CLLocationCoordinate2D
    var narrative: String
    var polyline: [CLLocation]
    
    init(maneuver: String, start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, narrative: String, polyline: [CLLocation]){
        self.maneuver = maneuver
        self.start = start
        self.end = end
        self.narrative = narrative
        self.polyline = polyline
    }
}