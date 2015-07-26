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
    @IBOutlet weak var interestDescriptLabel: UILabel!
    
    private func updateUI()
    {
        interestTitleLabel?.text! = interest.title
        interestDescriptLabel?.text! = interest.description
        featuredImageView?.image = interest.featuredImage
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
}
