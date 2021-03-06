//
//  Place.swift
//  Corsaire
//
//  Created by Elie on 21/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var distance: Int?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, distance: Int, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.distance = distance
    }
}
