//
//  PostsViewController.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit
import RFQuiltLayout
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
        for aClass: AnyClass in [TextPostView.self, ImagePostView.self] {
            self.collectionView?.registerNib(UINib(nibName: className(aClass), bundle: nil),
                forCellWithReuseIdentifier: className(aClass))
        }
        
        // Setup layout
        self.collectionView?.contentInset = UIEdgeInsets(top: 70, left: 10, bottom: 10, right: 10)
        
        let layout: RFQuiltLayout? = self.collectionView?.collectionViewLayout as? RFQuiltLayout
        layout?.direction = UICollectionViewScrollDirection.Vertical;
        layout?.blockPixels = CGSize(width: 10, height: 10)
        layout?.delegate = self
        
        // Setup data
        self.setCoordinate(CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: 0)
    }
    
    // Location & Data
    var posts: [Post] = []
    func setCoordinate(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        self.posts = []
        TwitterManager.fetchPosts(coordinate, radius: radius, response: { (post: Post) in
            self.addPost(post)
        })
    }
    
    func addPost(post: Post) {
        self.collectionView?.performBatchUpdates({
            self.posts.append(post)
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: self.posts.count - 1, inSection: 0)])
        }, completion: nil)
    }
}

extension PostsViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    // FUCK EVERYTHING HERE vvv
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: PostView?
        let post = self.posts[indexPath.row]
        
        if post.imageURL == nil {
            var textCell = collectionView.dequeueReusableCellWithReuseIdentifier(className(TextPostView.self),
                forIndexPath: indexPath) as? TextPostView
            
            textCell?.handle = post.user.handle
            textCell?.avatarImageURL = post.user.avatarImageURL
            textCell?.source = post.source
            textCell?.text = post.text
            textCell?.pubdate = post.pubdate
            textCell?.place = post.place.name
            
            cell = textCell
        } else {
            var imageCell = collectionView.dequeueReusableCellWithReuseIdentifier(className(ImagePostView.self),
                forIndexPath: indexPath) as? ImagePostView
            cell = imageCell
        }
        
        
        return cell!
    }
}

extension PostsViewController: UICollectionViewDelegate {
}

extension PostsViewController: RFQuiltLayoutDelegate {
    func blockSizeForItemAtIndexPath(indexPath: NSIndexPath!) -> CGSize {
        let post = self.posts[indexPath.row]
        
        if post.imageURL == nil {
            return CGSize(width: 17.5, height: 14.5)
        } else {
            return CGSize(width: 17.5, height: 32.0)
        }
    }
}