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

func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
    let count = countElements(list)
    for i in 0..<(count - 1) {
        let j = Int(arc4random_uniform(UInt32(count - i))) + i
        swap(&list[i], &list[j])
    }
    return list
}