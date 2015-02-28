//
//  Viewer.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import MapKit

class Viewer: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var lastCoordinate: CLLocationCoordinate2D?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}