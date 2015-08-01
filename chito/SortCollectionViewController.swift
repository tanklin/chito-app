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
        self.title = "美食探索"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 111.0/255.0, blue: 28.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = false;
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
//        kID = (indexPath.item)
        println((indexPath.item)+1)
//        var indexNum = (indexPath.item)+1
//        println(indexNum)
        return cell
    }
}

extension SortCollectionViewController : UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        kID = (indexPath.item)
        println("Row \(kID) was selected!!")
    }
}

extension SortCollectionViewController : UIScrollViewDelegate
{
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumInteritemSpacing

        var offset = targetContentOffset.memory

        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.memory = offset
    }
}