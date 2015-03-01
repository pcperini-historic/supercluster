//
//  TwitterManager.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit
import MapKit

class TwitterManager: APIManager {
    override internal class var host: String {
        return NSBundle.mainBundle().pathForResource("twitter_final", ofType: "txt")!
    }
    
    override internal class func postFromDictionary(dictionary: NSDictionary) -> Post {
        return Post(tweetData: dictionary)
    }
}

extension Post {
    init(tweetData: NSDictionary) {
        var userData: NSDictionary = tweetData["user"] as NSDictionary
        
        var imageURL: NSURL?
        if let imageURLString = ((tweetData["extended_entities"]?["media"] as? NSArray)?[0] as? NSDictionary)?["media_url"] as? String {
             imageURL = NSURL(string: imageURLString)
        }

        self.init(text: tweetData["text"] as? String,
            imageURL: imageURL,
            source: SourceType.Twitter,
            user: User(tweetData: userData),
            place: Place(tweetData: tweetData),
            pubdate: NSDate(timeIntervalSince1970: NSTimeInterval((tweetData["timestamp_ms"] as NSString).doubleValue / 1000.0)))
    }
}

extension User {
    init(tweetData: NSDictionary) {
        self.init(handle: tweetData["screen_name"] as String,
            avatarImageURL: NSURL(string: tweetData["profile_image_url"] as String)!)
    }
}

extension Place {
    init(tweetData: NSDictionary) {
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -1, longitude: -1)
        if let coord: [NSNumber] = tweetData["geo"]?["coordinates"] as? [NSNumber] {
            coordinate.latitude = CLLocationDegrees(coord[0])
            coordinate.longitude = CLLocationDegrees(coord[1])
        }
        
        var placeName: String? = tweetData["place"]?["name"] as? String
        self.init(coordinate: coordinate,
            name: placeName,
            userCount: nil,
            category: nil)
    }
}