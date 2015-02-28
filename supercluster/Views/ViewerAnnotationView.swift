//
//  ViewerAnnotationView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import MapKit

class ViewerAnnotationView: MKAnnotationView {
    // Initializers
    convenience init(viewer: Viewer) {
        self.init(annotation: viewer, reuseIdentifier: className(ViewerAnnotationView))
        
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.opaque = false
    }
    
    // Blip Drawing
    var blipView: UIView?
    override func drawRect(rect: CGRect) {
        self.addBlipView()
    }
    
    private func addBlipView() {
        if self.blipView != nil {
            return
        }
        
        self.blipView = UIView(frame: CGRectInset(self.bounds,
            self.bounds.width * 0.33,
            self.bounds.height * 0.33))
        
        self.blipView?.layer.cornerRadius = self.blipView!.bounds.width / 2.0
        self.blipView?.backgroundColor = self.tintColor
        self.addSubview(self.blipView!)
        
        // Start animating
        let expansion = CABasicAnimation(keyPath: "transform.scale")
        expansion.toValue = 2.0
        expansion.duration = 2.0
        expansion.repeatCount = FLT_MAX
        
        self.layer.addAnimation(expansion, forKey: "expansion")
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.toValue = 0.0
        fade.duration = 2.0
        fade.repeatCount = FLT_MAX
        
        self.layer.addAnimation(fade, forKey: "fade")
    }
}