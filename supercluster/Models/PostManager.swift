//
//  PostManager.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit
import MapKit

class PostManager: NSObject {
    // Process:
    //  build a corpus of 20 posts, largely at random
    //  sleep for random interval, adding new posts occasionally
    
    private var sleeping: Bool = false
    func fetchPosts(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, handler: (post: Post) -> ()) {
        var posts: [Post] = []
    
        // Twitter
        TwitterManager.fetchPosts(coordinate, radius: radius, size: 5, response: { (post: Post) in
            posts.append(post)
            
            if posts.count >= 15 {
                self.emptyBuffer(posts, handler: handler)
                posts = []
            }
        })
        
        // Instagram
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let instagramPosts = InstagramManager.posts(coordinate, radius: radius, size: 5)
            posts.extend(instagramPosts)
            
            if posts.count >= 15 {
                self.emptyBuffer(posts, handler: handler)
                posts = []
            }
        })
        
        // Foursquare
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let foursquarePosts = FoursquareManager.posts(coordinate, radius: radius, size: 5)
            posts.extend(foursquarePosts)
            
            if posts.count >= 15 {
                self.emptyBuffer(posts, handler: handler)
                posts = []
            }
        })
    }
    
    private func emptyBuffer(posts: [Post], handler: (post: Post) -> ()) {
        let shuffledPosts = shuffle(posts)
        for post in shuffledPosts {
            dispatch_async(dispatch_get_main_queue(), {
                handler(post: post)
            })
        }
    }
}
