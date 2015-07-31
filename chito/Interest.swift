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
            Interest(title: "美式料理",
                description: "漢堡,牛排,BBQ",
                featuredImage: UIImage(named: "sort_hamburger")!), // 1

            Interest(title: "義式料理",
                description: "義大利麵,披薩",
                featuredImage: UIImage(named: "sort_italian")!), // 2

            Interest(title: "日式料理",
                description: "壽司,丼飯,壽喜燒",
                featuredImage: UIImage(named: "sort_japan")!), // 3

            Interest(title: "咖啡、簡餐",
                description: "拿鐵,輕食,帕尼尼",
                featuredImage: UIImage(named: "sort_coffee")!), // 4

            Interest(title: "韓式料理",
                description: "辣炒年糕,銅板烤肉",
                featuredImage: UIImage(named: "sort_korean")!), // 5

//            Interest(title: "TGI.Friday Cheer!!!",
//                description: "In here, it's always Friday",
//                featuredImage: UIImage(named: "sort_beer")!) // 6
        ]
    }
}
