//
//  ClusterView.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit

@IBDesignable class ClusterView: UIView {
    // Animation
    @IBInspectable var rotatesClockwise: Bool = true {
        didSet {
            self.updateRotation()
        }
    }
    
    @IBInspectable var rotationDuration: CGFloat = 0 {
        didSet {
            self.updateRotation()
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            for ring: UIView in self.rings {
                ring.layer.borderColor = self.tintColor.CGColor
                for pip: UIView in ring.subviews as [UIView] {
                    pip.backgroundColor = self.tintColor
                }
            }
        }
    }
    
    private func updateRotation() {
        if (self.rotationDuration <= 0) {
            for ring: UIView in self.rings {
                ring.layer.removeAnimationForKey("rotation")
            }
            return
        }
        
        var flip: Bool = false
        for ring: UIView in self.rings {
            let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = (2 * M_PI) * (self.rotatesClockwise ? -1 : 1) * (flip ? -1 : 1)
            rotation.duration = NSTimeInterval(self.rotationDuration)
            rotation.repeatCount = FLT_MAX
            
            ring.layer.addAnimation(rotation, forKey: "rotation")
            flip = !flip
        }
    }
    
    // Drawing
    private var rings: [UIView] = []
    override func drawRect(rect: CGRect) {
        self.addRings()
    }
    
    private func addRings() {
        if self.rings.count > 0 {
            return
        }
        
        // First ring
        var firstRing = UIView(frame: CGRectInset(self.bounds,
            (self.bounds.width * 0.38),
            (self.bounds.height * 0.38)))
        
        firstRing.layer.cornerRadius = firstRing.bounds.height / 2.0
        firstRing.layer.borderColor = self.tintColor.CGColor
        firstRing.layer.borderWidth = 3
        self.addSubview(firstRing)
        
        // Second ring
        var secondRing = UIView(frame: CGRectInset(self.bounds,
            (self.bounds.width * 0.22),
            (self.bounds.height * 0.22)))
        
        secondRing.layer.cornerRadius = secondRing.bounds.height / 2.0
        secondRing.layer.borderColor = self.tintColor.CGColor
        secondRing.layer.borderWidth = 3
        
        var secondRingFirstPip = UIView(frame: CGRect(
            x: (secondRing.bounds.width - 9.0) / 2.0,
            y: secondRing.bounds.height - 6.5,
            width: 9.0,
            height: 9.0))
        
        secondRingFirstPip.layer.cornerRadius = secondRingFirstPip.bounds.height / 2.0
        secondRingFirstPip.backgroundColor = self.tintColor
        secondRing.addSubview(secondRingFirstPip)
        self.addSubview(secondRing)
        
        // Third ring
        var thirdRing = UIView(frame: CGRectInset(self.bounds,
            (self.bounds.width * 0.05),
            (self.bounds.height * 0.05)))
        
        thirdRing.layer.cornerRadius = thirdRing.bounds.height / 2.0
        thirdRing.layer.borderColor = self.tintColor.CGColor
        thirdRing.layer.borderWidth = 3
        
        var thirdRingFirstPip = UIView(frame: CGRect(
            x: -4.0,
            y: (thirdRing.bounds.height - 12.0) / 2.0,
            width: 12.0,
            height: 12.0))
        
        thirdRingFirstPip.layer.cornerRadius = thirdRingFirstPip.bounds.height / 2.0
        thirdRingFirstPip.backgroundColor = self.tintColor
        thirdRing.addSubview(thirdRingFirstPip)
        
        var thirdRingSecondPip = UIView(frame: CGRect(
            x: (thirdRing.bounds.width - 12.0) - 2.0,
            y: (thirdRing.bounds.height - 12.0) / 9.0,
            width: 12.0,
            height: 12.0))
        
        thirdRingSecondPip.layer.cornerRadius = thirdRingSecondPip.bounds.height / 2.0
        thirdRingSecondPip.backgroundColor = self.tintColor
        thirdRing.addSubview(thirdRingSecondPip)
        self.addSubview(thirdRing)
        
        self.rings = [firstRing, secondRing, thirdRing]
        self.updateRotation()
    }
}
