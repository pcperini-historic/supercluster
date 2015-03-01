//
//  TextPostView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit

class TextPostView: PostView {    
    // Sizing
    override class func estimatedSize(post: Post) -> CGSize {
        var cell = TextPostView(nib: nil)
        cell.awakeFromNib()
        
        var size = cell.bounds.size
        let originalTextViewSize = cell.textView!.bounds.size
        
        cell.text = post.text
        cell.textView?.sizeToFit()
        
        let newTextViewSize = cell.textView!.bounds.size
        
        size.height += (newTextViewSize.height - originalTextViewSize.height)
        size.width = UIScreen.mainScreen().bounds.width - 20
        
        return size
    }
    
    // Author
    @IBOutlet internal var avatarView: LazyImageView?
    @IBOutlet internal var handleLabel: UILabel?
    @IBOutlet internal var sourceIconView: UIImageView?
    
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
                    self.sourceIconView?.image = UIImage(named: "Twitter")
                    break
                    
                case .Instagram:
                    self.sourceIconView?.image = UIImage(named: "Instagram")
                    break
                    
                case .Foursquare:
                    self.sourceIconView?.image = UIImage(named: "Foursquare")
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    // Text
    @IBOutlet internal var textView: UITextView?
    var text: String? {
        get {
            return self.textView?.text
        }
        
        set {
            self.textView?.text = newValue
        }
    }
    
    // Metadata
    @IBOutlet internal var pubdateLabel: UILabel?
    @IBOutlet internal var placeLabel: UILabel?
    
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
