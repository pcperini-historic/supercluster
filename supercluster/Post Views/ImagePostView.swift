//
//  ImagePostView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit

class ImagePostView: TextPostView {
    // Sizing
    override class func estimatedSize(post: Post) -> CGSize {
        var cell = ImagePostView(nib: nil)
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
    
    // Image
    @IBOutlet internal var imageView: LazyImageView?
    
    var imageURL: NSURL? {
        didSet {
            self.imageView?.imageURL = self.imageURL
        }
    }
}
