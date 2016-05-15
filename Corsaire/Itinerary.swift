//
//  Itinerary.swift
//  Corsaire
//
//  Created by Elie on 15/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation

class Itinerary {
    var startAddress: String
    var destination: String
    var time: Int
    var distance: Int
    var steps: [Step]
    var polyline: String
    var tempsText: String
    var distanceText: String
    var name: String
    
    init(startAddress: String, destination: String, time: Int, distance: Int, steps: [Step], polyline: String, tempsText: String, distanceText: String, name: String){
        self.startAddress = startAddress
        self.destination = destination
        self.time = time
        self.distance = distance
        self.steps = steps
        self.polyline = polyline
        self.tempsText = tempsText
        self.distanceText = distanceText
        self.name = name
        
    }


}