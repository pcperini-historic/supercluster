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
    
    // Cluster & Viewers
    @IBOutlet var clusterView: ClusterView?
    var viewerManager: ViewerManager?
    
    // View Lifecycle
    override func viewDidLoad() {
        self.clusterSingleTapGestureRecognizer?.requireGestureRecognizerToFail(self.clusterDoubleTapGestureRecognizer!)
        self.viewerManager = ViewerManager(delegate: self)
    }
    
    // Gestures
    @IBOutlet var clusterSingleTapGestureRecognizer: UITapGestureRecognizer?
    @IBOutlet var clusterDoubleTapGestureRecognizer: UITapGestureRecognizer?
    @IBAction func clusterWasTapped(recognizer: UITapGestureRecognizer) {
//        switch recognizer.numberOfTapsRequired {
//        case 1:
//            break;
//            
//        case 2:
//            if var camera: MKMapCamera = self.mapView?.camera.copy() as? MKMapCamera {
//                UIView.animate([
//                    // Bounce Cluster
//                    (0.15, {
//                        self.clusterView?.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1.00)
//                        return
//                    }),
//                    (0.15, {
//                        self.clusterView?.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1.00)
//                        return
//                    }),
//                    (0.05, {
//                        self.clusterView?.layer.transform = CATransform3DIdentity
//                        return
//                    }),
//                    
//                    (0.00, {
//                        // Zoom map
//                        camera.altitude /= 10
//                        self.mapView?.setCamera(camera,
//                            animated: true)
//                    }),
//                ])
//            }
//            
//            break;
//            
//        default:
//            break;
//        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {        
//        if self.mapView?.camera.altitude <= searchableCameraAltitude {
//            self.clusterView?.tintColor = UIColor(red: 0.13, green: 0.75, blue: 0.80, alpha: 1.00)
//            self.clusterView?.rotationDuration = 2
//        }
        
        self.viewerManager?.viewingCoordinate = mapView.centerCoordinate
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var viewerView = ViewerAnnotationView(viewer: annotation as Viewer)
        viewerView.tintColor = UIColor(red: 0.94, green: 0.22, blue: 0.44, alpha: 1.00)
        return viewerView
    }
}

extension MapViewController: ViewerManagerDelegate {
    func viewerManager(viewManager: ViewerManager, didAddCoordinate coordinate: CLLocationCoordinate2D) {
        self.mapView?.addAnnotation(Viewer(coordinate: coordinate))
    }
    
    func viewerManager(viewManager: ViewerManager, didRemoveCoordinate coordinate: CLLocationCoordinate2D) {
        for annotation: MKAnnotation in self.mapView!.annotations as [MKAnnotation] {
            if coordinate == annotation.coordinate {
                self.mapView?.removeAnnotation(annotation)
                break
            }
        }
    }
}
