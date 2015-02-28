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
    let searchableCameraAltitude: CLLocationDistance = 600_000.00
    var startingCameraAltitude: CLLocationDistance?
    
    // Cluster
    @IBOutlet var clusterView: ClusterView?
    
    // View Lifecycle
    override func viewDidLoad() {
        self.clusterSingleTapGestureRecognizer?.requireGestureRecognizerToFail(self.clusterDoubleTapGestureRecognizer!)
        self.startingCameraAltitude = self.mapView?.camera.altitude
    }
    
    // Gestures
    @IBOutlet var clusterSingleTapGestureRecognizer: UITapGestureRecognizer?
    @IBOutlet var clusterDoubleTapGestureRecognizer: UITapGestureRecognizer?
    @IBAction func clusterWasTapped(recognizer: UITapGestureRecognizer) {
        switch recognizer.numberOfTapsRequired {
        case 1:
            break;
            
        case 2:
            if var camera: MKMapCamera = self.mapView?.camera.copy() as? MKMapCamera {
                UIView.animate([
                    // Bounce Cluster
                    (0.15, {
                        self.clusterView?.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1.00)
                        return
                    }),
                    (0.15, {
                        self.clusterView?.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1.00)
                        return
                    }),
                    (0.05, {
                        self.clusterView?.layer.transform = CATransform3DIdentity
                        return
                    }),
                    
                    (0.00, {
                        // Zoom map
                        camera.altitude /= 10
                        self.mapView?.setCamera(camera,
                            animated: true)
                    }),
                ])
            }
            
            break;
            
        default:
            break;
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        self.clusterView?.layer.transform = CATransform3DMakeScale(
            CGFloat(self.startingCameraAltitude! / mapView.camera.altitude),
            CGFloat(self.startingCameraAltitude! / mapView.camera.altitude), 1.00)
        
        if self.mapView?.camera.altitude <= searchableCameraAltitude {
            self.clusterView?.tintColor = UIColor(red: 0.13, green: 0.75, blue: 0.80, alpha: 1.00)
        }
    }
}
