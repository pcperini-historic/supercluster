//
//  InstagramManager.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation
import MapKit

class InstagramManager: APIManager {
    override internal class var host: String {
        return ""
    }
    
    override internal class func postFromDictionary(dictionary: NSDictionary) -> Post {
        return Post(instagramData: dictionary["data"] as NSDictionary)
    }
}

extension Post {
    init(instagramData: NSDictionary) {
        var userData: NSDictionary = instagramData["user"] as NSDictionary
        var imageURL: NSURL? = NSURL(string: instagramData["extended_entities"]?["media_url"] as String)
        
        self.init(text: instagramData["caption"]?["text"] as? String,
            imageURL: imageURL,
            source: SourceType.Instagram,
            user: User(instagramData: userData),
            place: Place(instagramData: instagramData["location"] as NSDictionary),
            pubdate: NSDate(timeIntervalSince1970: NSTimeInterval(instagramData["created_time"] as NSNumber)))
    }
}

extension User {
    init(instagramData: NSDictionary) {
        self.init(handle: instagramData["username"] as String,
            avatarImageURL: NSURL(string: instagramData["profile_picture"] as String)!)
    }
}

extension Place {
    init(instagramData: NSDictionary) {
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -1, longitude: -1)
        if let lat: NSNumber = instagramData["latitude"] as? NSNumber {
            coordinate.latitude = CLLocationDegrees(lat)
        }
        if let lon: NSNumber = instagramData["longitude"] as? NSNumber {
            coordinate.longitude = CLLocationDegrees(lon)
        }
        
        var placeName: String? = instagramData["name"] as? String
        self.init(coordinate: coordinate,
            placeName: placeName)
    }
}