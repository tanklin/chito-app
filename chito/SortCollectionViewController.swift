//
//  SortCollectionViewController.swift
//  CHiTO
//
//  Created by Tank Lin on 2015/7/21.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

import UIKit

class SortCollectionViewController: UIViewController
{
    // IBOutlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
//    @IBOutlet weak var currentUserProfileImageButton: UIButton!
//    @IBOutlet weak var currentUserFullNameButton: UIButton!
    
    
    // UICollectionViewDataSource
    private var interests = Interest.createInterests()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        self.title = "心情"
    }
    
    private struct Storyboard {
        static let CellIdentifier = "Interest Cell"
    }
}

extension SortCollectionViewController: UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        println(interests.count)
        return interests.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! InterestCollectionViewCell
        
        cell.interest = self.interests[indexPath.item]
        
        return cell
    }
}