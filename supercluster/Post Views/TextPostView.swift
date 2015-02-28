//
//  TextPostView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit

class TextPostView: PostView {
    // Author
    @IBOutlet private var avatarView: LazyImageView?
    @IBOutlet private var handleLabel: UILabel?
    @IBOutlet private var sourceIconView: UIImageView?
    
    var avatarImageURL: NSURL? {
        didSet {
            self.avatarView?.imageURL = self.avatarImageURL
        }
    }
    
    var handle: String? {
        get {
            return self.handleLabel?.text
        }
        
        set {
            self.handleLabel?.text = newValue
        }
    }
    
    var source: Post.SourceType? {
        didSet {
            self.sourceIconView?.image = nil
            if let source = self.source {
                switch source {
                case .Twitter:
                    break
                    
                case .Instagram:
                    break
                    
                case .Foursquare:
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    // Text
    @IBOutlet private var textView: UITextView?
    var text: String? {
        get {
            return self.textView?.text
        }
        
        set {
            self.textView?.text = newValue
        }
    }
    
    // Metadata
    @IBOutlet private var pubdateLabel: UILabel?
    @IBOutlet private var placeLabel: UILabel?
    
    var pubdate: NSDate? {
        didSet {
            let formatter: NSDateFormatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            self.pubdateLabel?.text = formatter.stringFromDate(self.pubdate ?? NSDate())
        }
    }
    
    var place: String? {
        get {
            return self.placeLabel?.text
        }
        
        set {
            self.placeLabel?.text = newValue
        }
    }
}
