//
//  Post.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation

struct Post {
    enum SourceType {
        case None
        case Twitter
        case Instagram
        case Foursquare
    }
    
    var text: String?
    var imageURL: NSURL?
    var source: SourceType
    var user: User
    var place: Place
    var pubdate: NSDate
}