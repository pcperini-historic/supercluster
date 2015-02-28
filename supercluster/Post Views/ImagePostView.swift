//
//  ImagePostView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit

class ImagePostView: PostView {
    // Image
    @IBOutlet private var imageView: UIImageView?
    
    var image: UIImage? {
        get {
            return self.imageView?.image
        }
        
        set {
            self.imageView?.image = newValue
        }
    }
    
    // Author
    @IBOutlet private var avatarView: UIImageView?
    @IBOutlet private var handleLabel: UILabel?
    @IBOutlet private var sourceIconView: UIImageView?
    
    var avatarImage: UIImage? {
        get {
            return self.avatarView?.image
        }
        
        set {
            self.avatarView?.image = newValue
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
    
    var source: PostView.SourceType? {
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
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = NSDateFormatterStyle.MediumStyle
            
            self.placeLabel?.text = formatter.stringFromDate(self.pubdate ?? NSDate())
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
