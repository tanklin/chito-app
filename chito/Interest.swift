//
//  Interest.swift
//  CHiTO
//
//  Created by Tank Lin on 2015/7/21.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

import UIKit

class Interest
{
    // Public API
    var title = ""
    var description = ""
    var numberOfMembers = 0
    var numberOfPost = 0
    var featuredImage: UIImage!
    
    init(title: String, description: String, featuredImage: UIImage!)
    {
        self.title = title
        self.description = description
        self.featuredImage = featuredImage
        numberOfMembers = 1
        numberOfPost = 1
    }
    
    // Private
    
    static func createInterests() -> [Interest]
    {
        return [
            Interest(title: "We Love Hamburgers", description: "We recommand this restaurant", featuredImage: UIImage(named: "sort_hamburger")!),
            Interest(title: "Enjoy Coffee Time", description: "Why not have ac cup of coffee with your best family", featuredImage: UIImage(named: "sort_coffee")!),
            Interest(title: "Let's Cocoa", description: "Best Choice", featuredImage: UIImage(named: "sort_cocoa")!),
            Interest(title: "It's Tea Time", description: "Make time, make Tetley.", featuredImage: UIImage(named: "sort_teatime")!),
            Interest(title: "Dinner with Family", description: "Life tastes better with Family", featuredImage: UIImage(named: "sort_dinner")!),
            Interest(title: "TGI.Friday Cheer!!!", description: "In here, it's always Friday", featuredImage: UIImage(named: "sort_beer")!)
        ]
    }
}
