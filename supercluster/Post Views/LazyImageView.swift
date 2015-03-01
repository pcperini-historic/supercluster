//
//  LazyImageView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit
import Alamofire

@IBDesignable class LazyImageView: UIImageView {
    var imageURL: NSURL? {
        didSet {
            if let path: String = self.imageURL?.absoluteString {
                Alamofire.request(.GET, path).response({ (_, _, data: AnyObject?, error) in
                    self.image = UIImage(data: data as NSData)
                })
            }
        }
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
