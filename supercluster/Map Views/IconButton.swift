//
//  IconButton.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit

@IBDesignable class IconButton: UIButton {
    @IBInspectable var rotation: CGFloat = 0.0 {
        didSet {
            self.layer.transform = CATransform3DMakeRotation(self.rotation * CGFloat(M_PI / 180.0), 0, 0, 1)
        }
    }
}
