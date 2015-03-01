//
//  CheckinPostView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit

class CheckinPostView: PostView {
    // Sizing
    override class func estimatedSize(post: Post) -> CGSize {
        var cell = CheckinPostView(nib: nil)
        cell.awakeFromNib()
        
        var size = cell.bounds.size
        size.width = UIScreen.mainScreen().bounds.width - 20
        
        return size
    }
    
    // Place
    @IBOutlet internal var handleLabel: UILabel?
    @IBOutlet internal var sourceIconView: UIImageView?
    
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
    @IBOutlet internal var userCountLabel: UILabel?
    var userCount: Int = 0 {
        didSet {
            self.userCountLabel?.text = "\(self.userCount) people here now."
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