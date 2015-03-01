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
        return NSBundle.mainBundle().pathForResource("foursquare_final", ofType: "json")!
    }
    
    override class func posts(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, size: Int = 20) -> [Post] {
        let response: NSDictionary = (NSString(contentsOfFile: self.host, encoding: NSUTF8StringEncoding, error: nil) as String).jsonObject as NSDictionary
        
        var posts: [Post] = []
        for entry: NSDictionary in (response["venues"] as [NSDictionary]) {
            let post = self.postFromDictionary(entry)
            
            if !post.place.isInRadius(radius, fromCoordinate: coordinate) {
                continue
            }
            
            posts.append(post)
            if posts.count >= size {
                break
            }
        }
        
        return posts
    }
    
    override internal class func postFromDictionary(dictionary: NSDictionary) -> Post {
        return Post(checkinData: dictionary as NSDictionary)
    }
}

extension Post {
    init(checkinData: NSDictionary) {
        self.init(text: nil,
            imageURL: nil,
            source: SourceType.Foursquare,
            user: nil,
            place: Place(checkinData: checkinData),
            pubdate: NSDate())
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
        var userCount: Int? = (checkinData["hereNow"]?["count"] as? NSNumber)?.integerValue
        var category: String? = checkinData["categories"]?[0]?["shortName"] as? String
        
        self.init(coordinate: coordinate,
            name: placeName,
            userCount: userCount,
            category: category)
    }
}