//
//  ViewerManager.swift
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import Foundation
import MapKit
import SIOSocket

protocol ViewerManagerDelegate {
    func viewerManager(viewManager: ViewerManager, didAddCoordinate coordinate: CLLocationCoordinate2D)
    func viewerManager(viewManager: ViewerManager, didRemoveCoordinate coordinate: CLLocationCoordinate2D)
}

class ViewerManager: NSObject {
    private class var host: String {
        return "http://127.0.0.1:3000"
    }
    
    private var socket: SIOSocket?
    var delegate: ViewerManagerDelegate
    
    private var lastViewedCoordinate: CLLocationCoordinate2D?
    var viewingCoordinate: CLLocationCoordinate2D? {
        willSet {
           self.lastViewedCoordinate = self.viewingCoordinate
        }
        
        didSet {
            if let lastViewedCoordinate = self.lastViewedCoordinate {
                self.socket?.emit("left", args: [lastViewedCoordinate.latitude, lastViewedCoordinate.longitude])
                
                if let viewingCoordinate = self.viewingCoordinate {
                    self.socket?.emit("location", args: [viewingCoordinate.latitude, viewingCoordinate.longitude])
                }
            }
        }
    }
    
    init(delegate: ViewerManagerDelegate) {
        self.delegate = delegate
        super.init()
        
        SIOSocket.socketWithHost(ViewerManager.host, response: { (socket: SIOSocket!) in
            socket.onConnect = {
                println("connected")
            }
            
            socket.onReconnect = { (retries: Int) in
                println("reconnected")
            }
            
            socket.on("update", callback: { (arguments: [AnyObject]!) in
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(arguments[0] as NSNumber),
                    longitude: CLLocationDegrees(arguments[1] as NSNumber))
                self.delegate.viewerManager(self, didAddCoordinate: location)
            })
            
            socket.on("disappear", callback: { (arguments: [AnyObject]!) in
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(arguments[0] as NSNumber),
                    longitude: CLLocationDegrees(arguments[1] as NSNumber))
                self.delegate.viewerManager(self, didRemoveCoordinate: location)
            })
            
            self.socket = socket
        })
    }
}
