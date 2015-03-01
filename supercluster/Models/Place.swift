//
//  Place.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation
import MapKit

struct Place {
    var coordinate: CLLocationCoordinate2D
    var name: String?
    var userCount: Int?
    var category: String?
    
    func isInRadius(radius: CLLocationDistance, fromCoordinate coord: CLLocationCoordinate2D) -> Bool {
        let placeLocation = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        let centerLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        
        println("dist: \(placeLocation.distanceFromLocation(centerLocation)), radius: \(radius)")
        return placeLocation.distanceFromLocation(centerLocation) <= radius
    }
}