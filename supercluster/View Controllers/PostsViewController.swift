//
//  PostsViewController.swift
//  supercluster
//
//  Created by Patrick Perini on 2/27/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

import UIKit
import RFQuiltLayout

class PostsViewController: UIViewController {
    // Views
    @IBOutlet var collectionView: UICollectionView?
    
    override func viewDidLoad() {
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
    }
}

extension PostsViewController: UICollectionViewDataSource { // FUCK EVERYTHING HERE
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: PostView?
        
        if indexPath.item % 2 == 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(className(TextPostView.self),
                forIndexPath: indexPath) as? PostView
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(className(ImagePostView.self),
                forIndexPath: indexPath) as? PostView
        }
        
        return cell!
    }
}

extension PostsViewController: UICollectionViewDelegate {
}

extension PostsViewController: RFQuiltLayoutDelegate {
    func blockSizeForItemAtIndexPath(indexPath: NSIndexPath!) -> CGSize {
        if indexPath.item % 2 == 0 {
            return CGSize(width: 17.5, height: 14.5)
        } else {
            return CGSize(width: 17.5, height: 32.0)
        }
    }
}