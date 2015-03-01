//
//  PostView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit

@IBDesignable class PostView: UICollectionViewCell {
    // Reuse
    override var reuseIdentifier: String {
        return className(self.dynamicType)
    }
    
    // Sizing
    class func estimatedSize(post: Post) -> CGSize {
        return CGSizeZero
    }
    
    // Border
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            self.layer.borderColor = self.borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
}
