//
//  WalkingStep.swift
//  Corsaire
//
//  Created by Elie on 15/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import MapKit

class WalkingStep: Step{
    
    override init(maneuver: String, start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, narrative: String, polyline: [CLLocation]){
        super.init(maneuver: maneuver, start: start, end: end, narrative: narrative, polyline: polyline)
    }
}