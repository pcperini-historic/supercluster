//
//  UIView+AnimationExtensions.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation

extension UIView {
    class func animate(animations: [(NSTimeInterval, () -> ())], completion: (() -> ())? = nil) {
        println("animating \(animations.count)")
        if animations.count <= 0 {
            if completion != nil {
                completion!()
            }
            
            return
        }
        
        var animationTuple = animations[0]
        var remainingAnimations = Array(animations[1..<animations.count])
        
        UIView.animateWithDuration(animationTuple.0, animations: animationTuple.1) { (completed: Bool) in
            UIView.animate(remainingAnimations, completion: completion)
        }
    }
}