//
//  InterfaceController.swift
//  supercluster WatchKit Extension
//
//  Created by Patrick Perini on 3/1/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var map: WKInterfaceMap?
    
    override init(context: AnyObject?) {
        // Initialize variables here.
        super.init(context: context)
        
        // Configure interface objects here.
        println("\(context)")
        self.map?.setMapRect(MKMapRectWorld)
    }

}
