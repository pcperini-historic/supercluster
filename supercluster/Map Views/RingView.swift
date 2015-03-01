//
//  RingView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit

@IBDesignable class RingView: UIView {
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    override func drawRect(rect: CGRect) {
        self.layer.borderColor = self.tintColor.CGColor
        self.layer.cornerRadius = self.bounds.width / 2.0
        self.layer.masksToBounds = true
    }
}
