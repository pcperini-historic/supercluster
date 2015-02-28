//
//  CLLocationCoordinate2D+Extensions.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable {
}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
}