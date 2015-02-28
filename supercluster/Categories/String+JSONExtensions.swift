//
//  String+JSONExtensions.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation

extension String {
    var jsonObject: AnyObject? {
        get {
            if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
                return NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.allZeros,
                    error: nil)
            } else {
                return nil
            }
        }
    }
    
    init(jsonObject: AnyObject) {
        if let data = NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.allZeros, error: nil) {
            self = NSString(data: data, encoding: NSUTF8StringEncoding) as String
        } else {
            self = ""
        }
    }
}