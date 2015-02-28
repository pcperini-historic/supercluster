//
//  APIManager.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation
import MapKit

class APIManager {
    internal class var host: String {
        return ""
    }
    
    // This is unimplemented at the top-level, because it relies on the schema for the response object.
    class func posts(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) -> [Post] {
        return []
    }
    
    // This, on the other hand, assumes a stream of newline-deliminated JSON dictionaries, a la Twitter's firehose.
    class func fetchPosts(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, response: (post: Post) -> ()) {
        // Background
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let streamReader: StreamReader? = StreamReader(path: self.host)
            while let line: String = streamReader?.nextLine() {
                let dict: NSDictionary = line.jsonObject as NSDictionary
                let post = self.postFromDictionary(dict)
                
                // Foreground
                dispatch_async(dispatch_get_main_queue(), {
                    response(post: post)
                })
            }
            
            streamReader?.close()
        })
    }
    
    internal class func postFromDictionary(dictionary: NSDictionary) -> Post {
        return Post(text: nil,
            imageURL: nil,
            source: Post.SourceType.None,
            user: User(handle: "", avatarImageURL: NSURL()),
            place: Place(coordinate: CLLocationCoordinate2D(latitude: -1, longitude: -1), name: nil),
            pubdate: NSDate())
    }
}