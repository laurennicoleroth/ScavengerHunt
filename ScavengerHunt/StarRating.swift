//
//  StarRating.swift
//  ScavengerHunt
//
//  Created by Lauren Nicole Roth on 5/20/16.
//  Copyright © 2016 Lauren Nicole Roth. All rights reserved.
//

import Foundation
import UIKit


class StarRating: UIImage {
    
    class func rating(rating: Double) -> (UIImage){
        
        var ratingImage:UIImage
        
        switch rating {
            
        case 0.0:
            ratingImage = UIImage(named:"zerostars")!
        case 0..<1.0:
            ratingImage = UIImage(named:"halfstars")!
        case 1.0:
            ratingImage = UIImage(named:"onestars")!
        case 1.0..<2.0:
            ratingImage = UIImage(named:"onehalfstars")!
        case 2.0:
            ratingImage = UIImage(named:"twostars")!
        case 2.0..<3.0:
            ratingImage = UIImage(named:"twohalfstars")!
        case 3.0:
            ratingImage = UIImage(named:"threestars")!
        case 3.0..<4.0:
            ratingImage = UIImage(named:"threehalfstars")!
        case 4.0:
            ratingImage = UIImage(named:"fourstars")!
        case 4.0..<5.0:
            ratingImage = UIImage(named:"fourhalfstars")!
        case 5.0:
            ratingImage = UIImage(named:"fivestars")!
        default:
            ratingImage = UIImage(named:"zerostars")!
        }
        
        return ratingImage
        
    }
    
    
    
}
