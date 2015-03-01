//
//  MapViewController.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    // Maps
    @IBOutlet var mapView: MKMapView?
    var mapViewPinchGestureRecognizer: UIPinchGestureRecognizer? {
        get {
            for recognizer: UIGestureRecognizer in ((self.mapView?.subviews[0] as UIView).gestureRecognizers as [UIGestureRecognizer]) {
                if let pinchRecognizer = recognizer as? UIPinchGestureRecognizer {
                    return pinchRecognizer
                }
            }
            
            return nil
        }
    }
    
    var maxCameraAltitude: CLLocationDistance = -1
    var hasZoomedInitialy: Bool = false
    
    // Cluster & Viewers
    @IBOutlet var outerRing: RingView?
    @IBOutlet var innerRing: RingView?
    @IBOutlet var innerRingWidthConstraint: NSLayoutConstraint?
    @IBOutlet var innerRingHeightConstraint: NSLayoutConstraint?
    @IBOutlet var outerRingWidthConstraint: NSLayoutConstraint?
    var innerRingInitialSize: CGSize = CGSizeZero
    
    var viewerManager: ViewerManager?
    
    // Shuttle Button
    @IBOutlet var shuttleButton: IconButton?
    @IBOutlet var shuttleButtonVerticalConstraint: NSLayoutConstraint?
    var shuttleButtonIsShowing: Bool = false
    
    // View Lifecycle
    override func viewDidLoad() {
        self.maxCameraAltitude = self.mapView!.camera.altitude
        self.innerRingInitialSize = CGSizeMake(self.innerRingWidthConstraint!.constant, self.innerRingHeightConstraint!.constant)
        
        self.viewerManager = ViewerManager(delegate: self)
        self.mapViewPinchGestureRecognizer?.addTarget(self, action: "mapViewPinchGestureWasRecognized:")
    }
    
    override func viewDidAppear(animated: Bool) {
        self.updateInnerRing(1.0)
    }
    
    // Gestures
    func mapViewPinchGestureWasRecognized(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case UIGestureRecognizerState.Changed:
            self.updateInnerRing(recognizer.scale)
            break
            
        default:
            break
        }
    }
    
    // Responders
    @IBAction func shuttleButtonWasPressed(sender: IconButton) {
        self.sendOutShuttleButton(toBottomEdge: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var postsVC = segue.destinationViewController as PostsViewController
        postsVC.backgroundImage = self.view.snapshot().applyBlurWithRadius(8,
            tintColor: UIColor(red: 0.10, green: 0.15, blue: 0.20, alpha: 0.40),
            saturationDeltaFactor: 1.8,
            maskImage: nil)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: self.mapView!.centerCoordinate.latitude, longitude: self.mapView!.centerCoordinate.longitude), completionHandler: { (placemarks: [AnyObject]!, _) in
            postsVC.title = placemarks[0].locality
        })
        
        let ringRegion = self.mapView!.convertRect(self.innerRing!.frame, toRegionFromView: self.view)
        
        let centerLocation = CLLocation(latitude: ringRegion.center.latitude, longitude: ringRegion.center.longitude)
        let satelliteLocation = CLLocation(latitude: ringRegion.center.latitude + (ringRegion.span.latitudeDelta / 2.0),
            longitude: ringRegion.center.longitude + (ringRegion.span.longitudeDelta / 2.0))
        
        postsVC.setCoordinate(self.mapView!.centerCoordinate,
            radius: centerLocation.distanceFromLocation(satelliteLocation))
    }
    
    // Visual Updaters
    func updateInnerRing(scale: CGFloat) {
        var modifiedScale = scale * 0.25
        
        var newHeight = modifiedScale * CGFloat(self.maxCameraAltitude / self.mapView!.camera.altitude) * self.innerRingInitialSize.height
        var newWidth = modifiedScale * CGFloat(self.maxCameraAltitude / self.mapView!.camera.altitude) * self.innerRingInitialSize.width
        
        if newWidth > self.outerRingWidthConstraint?.constant {
            newWidth = self.outerRingWidthConstraint!.constant
            newHeight = newWidth
            
            self.bringInShuttleButton()
        } else {
            self.sendOutShuttleButton()
        }
        
        self.innerRingHeightConstraint?.constant = newHeight
        self.innerRingWidthConstraint?.constant = newWidth
        
        self.innerRing?.setNeedsUpdateConstraints()
        self.innerRing?.setNeedsDisplay()
    }
    
    func bringInShuttleButton() {
        self.shuttleButtonIsShowing = true
        self.shuttleButtonVerticalConstraint?.constant = 0
        UIView.animateWithDuration(2.00, animations: {
            self.shuttleButton?.layoutIfNeeded()
            return
        })
    }
    
    func sendOutShuttleButton(toBottomEdge: Bool = true) {
        if !self.shuttleButtonIsShowing {
            return
        }
        
        self.shuttleButtonIsShowing = false
        if toBottomEdge {
            UIView.animate([
                (0.50, {
                    self.shuttleButton?.rotation = 135
                    return
                }),
                
                (2.00, {
                    self.shuttleButtonVerticalConstraint?.constant = toBottomEdge ? -200 : 500
                    self.shuttleButton?.layoutIfNeeded()
                })
            ], completion: {
                self.shuttleButton?.rotation = -45
                return
            })
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                UIView.animate([
                    (0.04, {
                        self.shuttleButton?.rotation = -50
                        return
                    }),
                    
                    (0.08, {
                        self.shuttleButton?.rotation = -40
                        return
                    }),
                    
                    (0.04, {
                        self.shuttleButton?.rotation = -45
                        return
                    }),
                    
                    (0.04, {
                        self.shuttleButton?.rotation = -50
                        return
                    }),
                    
                    (0.08, {
                        self.shuttleButton?.rotation = -40
                        return
                    }),
                    
                    (0.04, {
                        self.shuttleButton?.rotation = -45
                        return
                    }),
                    
                    (0.25, {
                        self.shuttleButtonVerticalConstraint?.constant = toBottomEdge ? -200 : 500
                        self.shuttleButton?.layoutIfNeeded()
                    })
                ], completion: {
                    self.shuttleButton?.rotation = -45
                    self.shuttleButtonVerticalConstraint?.constant = -200
                    self.shuttleButton?.setNeedsUpdateConstraints()
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("PostList", sender: self.shuttleButton)
                    })
                })
            })
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        if !self.hasZoomedInitialy {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                let camera: MKMapCamera = self.mapView!.camera.copy() as MKMapCamera
                camera.centerCoordinate = CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167)
                camera.altitude = 190000
                
                // Animate map
                self.mapView?.setCamera(camera, animated: true)
                
                // Animate size
                UIView.animate([
                    (3.0, {
                        self.innerRingHeightConstraint?.constant = self.outerRingWidthConstraint!.constant
                        self.innerRingWidthConstraint?.constant = self.outerRingWidthConstraint!.constant
                        
                        self.innerRing?.layoutIfNeeded()
                    })
                ])
                
                // Animate corner radius
                let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
                cornerRadiusAnimation.fromValue = self.innerRingWidthConstraint!.constant / 2.0
                cornerRadiusAnimation.toValue = self.outerRingWidthConstraint!.constant / 2.0
                cornerRadiusAnimation.duration = 3.0
                cornerRadiusAnimation.fillMode = kCAFillModeBoth
                
                self.innerRing?.layer.addAnimation(cornerRadiusAnimation, forKey: "cornerRadius")
                self.innerRing?.layer.cornerRadius = self.outerRingWidthConstraint!.constant / 2.0
                
                self.hasZoomedInitialy = true
            })
        }
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        self.updateInnerRing(1.0)
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
