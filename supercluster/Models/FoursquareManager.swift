//
//  FoursquareManager.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

//
//  InstagramManager.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation
import MapKit

class FoursquareManager: APIManager {
    override internal class var host: String {
        return ""
    }
    
    override internal class func postFromDictionary(dictionary: NSDictionary) -> Post {
        return Post(checkinData: dictionary["response"] as NSDictionary)
    }
}

extension Post {
    init(checkinData: NSDictionary) {
        self.init(text: nil,
            imageURL: nil,
            source: SourceType.Foursquare,
            user: User(checkinData: [:]),
            place: Place(checkinData: checkinData),
            pubdate: NSDate()))
    }
}

extension User {
    init(checkinData: NSDictionary) {
        self.init(handle: "",
            avatarImageURL: NSURL())
    }
}

extension Place {
    init(checkinData: NSDictionary) {
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -1, longitude: -1)
        if let lat: NSNumber = checkinData["location"]?["lat"] as? NSNumber {
            coordinate.latitude = CLLocationDegrees(lat)
        }
        if let lon: NSNumber = checkinData["location"]?["lng"] as? NSNumber {
            coordinate.longitude = CLLocationDegrees(lon)
        }
        
        var placeName: String? = checkinData["name"] as? String
        self.init(coordinate: coordinate,
            placeName: placeName)
    }
}