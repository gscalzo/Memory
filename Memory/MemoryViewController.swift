//
//  MemoryViewController.swift
//  Memory
//
//  Created by Giordano Scalzo on 18/11/2014.
//  Copyright (c) 2014 Swift by Example. All rights reserved.
//

import UIKit

class MemoryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private var collectionView: UICollectionView?
    private var deck: Deck!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.greenColor()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 60, height: 60*1.452)
        layout.minimumLineSpacing = 5
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CardCell.self, forCellWithReuseIdentifier: "cardCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        collectionView!.backgroundColor = UIColor.greenColor()
        
        let fullDeck = Deck.full().shuffled()
        let halfDeck = fullDeck.deckOfNumberOfCards(12)
        deck = (halfDeck + halfDeck).shuffled()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count()
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as CardCell
        cell.backgroundColor = UIColor.clearColor()
       
        let card = deck[indexPath.row]
        cell.renderCardName(card.description, backImageName: "back")
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as CardCell
        cell.show()
        
        let delay = 5.0
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), {cell.hide()})
    }
}

