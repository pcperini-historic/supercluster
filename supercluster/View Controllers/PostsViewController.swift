//
//  PostsViewController.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit
import MapKit

class PostsViewController: UIViewController {
    // Views
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var backgroundImageView: UIImageView?
    
    var backgroundImage: UIImage? {
        didSet {
            self.backgroundImageView?.image = self.backgroundImage
        }
    }
    
    override var title: String! {
        didSet {
            self.titleLabel?.text = self.title
        }
    }
    
    override func viewDidLoad() {
        self.backgroundImageView?.image = self.backgroundImage
        
        // Setup post views
        for aClass: AnyClass in [TextPostView.self, ImagePostView.self, CheckinPostView.self] {
            self.collectionView?.registerNib(UINib(nibName: className(aClass), bundle: nil),
                forCellWithReuseIdentifier: className(aClass))
        }
        
        // Setup layout
        self.collectionView?.contentInset = UIEdgeInsets(top: 70, left: 10, bottom: 10, right: 10)
        self.collectionView?.collectionViewLayout        
    }
    
    // Location & Data
    var posts: [Post] = []
    let postManager: PostManager = PostManager()
    func setCoordinate(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        self.posts = []
        self.postManager.fetchPosts(coordinate, radius: radius, handler: { (post: Post) in
            self.addPost(post)
        })
    }
    
    func addPost(post: Post) {
        self.collectionView?.performBatchUpdates({
            self.posts.append(post)
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: self.posts.count - 1, inSection: 0)])
        }, completion: nil)
    }
    
    // Responders
    @IBAction func doneButtonWasPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension PostsViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: PostView?
        let post = self.posts[indexPath.row]
        
        switch (post.user, post.imageURL) {
        case let (.Some(user), .Some(imageURL)):
            var imageCell = collectionView.dequeueReusableCellWithReuseIdentifier(className(ImagePostView.self),
                forIndexPath: indexPath) as? ImagePostView
            
            imageCell?.handle = post.user?.handle
            imageCell?.avatarImageURL = post.user?.avatarImageURL
            imageCell?.source = post.source
            imageCell?.text = post.text
            imageCell?.pubdate = post.pubdate
            imageCell?.place = post.place.name
            
            imageCell?.imageURL = post.imageURL
            cell = imageCell
            break
        
        case let (.Some(user), nil):
            var textCell = collectionView.dequeueReusableCellWithReuseIdentifier(className(TextPostView.self),
                forIndexPath: indexPath) as? TextPostView

            textCell?.handle = post.user?.handle
            textCell?.avatarImageURL = post.user?.avatarImageURL
            textCell?.source = post.source
            textCell?.text = post.text
            textCell?.pubdate = post.pubdate
            textCell?.place = post.place.name
            
            cell = textCell
            break
            
        case let (nil, nil):
            var checkinCell = collectionView.dequeueReusableCellWithReuseIdentifier(className(CheckinPostView.self),
                forIndexPath: indexPath) as? CheckinPostView
            
            checkinCell?.handle = post.place.name
            checkinCell?.source = post.source
            checkinCell?.userCount = post.place.userCount ?? 0
            checkinCell?.pubdate = post.pubdate
            checkinCell?.place = post.place.category ?? ""
            
            cell = checkinCell
            break
            
        default:
            break
        }
        
        return cell!
    }
}

extension PostsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let post = self.posts[indexPath.row]
        
        switch (post.user, post.imageURL) {
        case let (.Some(user), .Some(imageURL)):
            break
            
        case let (.Some(user), nil):
            break
            
        case let (nil, nil):
            if let mapVC = self.presentingViewController as? MapViewController {
                self.dismissViewControllerAnimated(true, completion: nil)
                
                let camera: MKMapCamera = mapVC.mapView!.camera.copy() as MKMapCamera
                camera.centerCoordinate = post.place.coordinate
                camera.altitude = 2000
                
                mapVC.mapView?.setCamera(camera, animated: true)
            }
            
            break
            
        default:
            break
        }

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let post = self.posts[indexPath.row]
        
        var size: CGSize = CGSizeZero
        
        switch (post.user, post.imageURL) {
        case let (.Some(user), .Some(imageURL)):
            size = ImagePostView.estimatedSize(post)
            break
            
        case let (.Some(user), nil):
            size = TextPostView.estimatedSize(post)
            break
            
        case let (nil, nil):
            size = CheckinPostView.estimatedSize(post)
            break
            
        default:
            break
        }
        
        return size
    }
}