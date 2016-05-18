//
//  ValidHomeMapDelegate.swift
//  Corsaire
//
//  Created by Elie on 18/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation
import MapKit

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