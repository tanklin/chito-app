//
//  InterestCollectionViewCell.swift
//  CHiTO
//
//  Created by Tank Lin on 2015/7/21.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

//import Cocoa
import UIKit

class InterestCollectionViewCell: UICollectionViewCell
{
    // Public API
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    // private
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    
    private func updateUI()
    {
        interestTitleLabel?.text! = interest.title
        featuredImageView?.image = interest.featuredImage
    }
}
