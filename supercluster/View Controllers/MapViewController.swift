//
//  MapViewController.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    // Maps
    @IBOutlet var mapView: MKMapView?
    
    // View Lifecycle
    override func viewDidLoad() {
        self.clusterSingleTapGestureRecognizer?.requireGestureRecognizerToFail(self.clusterDoubleTapGestureRecognizer!)
    }
    
    // Gestures
    @IBOutlet var clusterSingleTapGestureRecognizer: UITapGestureRecognizer?
    @IBOutlet var clusterDoubleTapGestureRecognizer: UITapGestureRecognizer?
    @IBAction func clusterWasTapped(recognizer: UITapGestureRecognizer) {
        switch recognizer.numberOfTapsRequired {
        case 1:
            break;
            
        case 2:
            if var camera = self.mapView?.camera {
                // Bounce Cluster
                UIView.animateWithDuration(0.15, animations: {
                    recognizer.view?.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1.00)
                    return
                }, completion: { (value: Bool) in
                    UIView.animateWithDuration(0.15, animations: {
                        recognizer.view?.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1.00)
                        return
                    }, completion: { (value: Bool) in
                        UIView.animateWithDuration(0.05, animations: {
                            recognizer.view?.layer.transform = CATransform3DIdentity
                            // Zoom map
                            camera.altitude = 1
                            self.mapView?.setCamera(camera,
                                animated: true)
                        })
                    })
                })
            }
            
            break;
            
        default:
            break;
        }
    }
}
