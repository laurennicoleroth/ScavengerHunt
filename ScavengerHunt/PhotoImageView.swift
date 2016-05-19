//
//  PhotoImageView.swift
//  ScavengerHunt
//
//  Created by Lauren Nicole Roth on 5/19/16.
//  Copyright © 2016 Lauren Nicole Roth. All rights reserved.
//

import UIKit

class PhotoImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 2   //round the corner of photo
        self.layer.masksToBounds = true
        self.contentMode = .ScaleAspectFill
    }

}
