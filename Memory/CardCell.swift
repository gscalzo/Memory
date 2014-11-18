//
//  CardCell.swift
//  Memory
//
//  Created by Giordano Scalzo on 18/11/2014.
//  Copyright (c) 2014 Swift by Example. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    let imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
        contentView.backgroundColor = UIColor.clearColor()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
