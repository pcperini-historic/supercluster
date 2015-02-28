//
//  Post.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation
import MapKit

struct Post {
    enum SourceType {
        case Twitter
        case Instagram
        case Foursquare
    }
    
    var coordinate: CLLocationCoordinate2D
    var text: String
    var image: UIImage
    var source: SourceType
    var username: String
}