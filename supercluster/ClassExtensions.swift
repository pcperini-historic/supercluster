//
//  ClassExtensions.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation

func className(classType: AnyClass) -> String {
    var className = NSStringFromClass(classType)
    if let range = className.rangeOfString(".") {
        className = className.componentsSeparatedByString(".").last
    }
    
    return className
}