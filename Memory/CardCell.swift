//
//  CardCell.swift
//  Memory
//
//  Created by Giordano Scalzo on 18/11/2014.
//  Copyright (c) 2014 Swift by Example. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    private let imageView: UIImageView!
    private var cardImageName: String!
    private var backImageName: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        contentView.addSubview(imageView)
        contentView.backgroundColor = UIColor.clearColor()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderCardName(cardImageName: String, backImageName: String){
        self.cardImageName = cardImageName
        self.backImageName = backImageName
        self.imageView.image = UIImage(named: self.backImageName)
    }
    
    func show() {
        UIView.transitionWithView(contentView,
            duration: 1,
            options: .TransitionFlipFromRight,
            animations: {
                self.imageView.image = UIImage(named: self.cardImageName)
            },
            completion: nil)
    }

    func hide() {
        UIView.transitionWithView(contentView,
            duration: 1,
            options: .TransitionFlipFromLeft,
            animations: {
                self.imageView.image = UIImage(named: self.backImageName)
            },
            completion: nil)
    }

}