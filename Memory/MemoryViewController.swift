//
//  MemoryViewController.swift
//  Memory
//
//  Created by Giordano Scalzo on 18/11/2014.
//  Copyright (c) 2014 Swift by Example. All rights reserved.
//


//TODO
//0 - handle different resolution
//1 - pretty disappear (saving indexes?)
//2 - remove external state for visibility (saving indexes?)
//3 - refactor for better code
//4 - split in small chunck





import UIKit

class MemoryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private var collectionView: UICollectionView?
    private var deck: Deck!
    private var cardVisibility: Array<Bool>!
    private var firstCard: CardCell?
    private var secondCard: CardCell?
    private var numberOfPairs = 0
    private var numberOfTries = 0
    
    
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
        
        start()
    }
    
    private func start() {
        numberOfPairs = 0
        numberOfTries = 0

        deck = createDeck()
        cardVisibility = Array<Bool>(count: deck.count(), repeatedValue: true)
        collectionView!.reloadData()
    }
    
    private func createDeck() -> Deck {
        let fullDeck = Deck.full().shuffled()
        let halfDeck = fullDeck.deckOfNumberOfCards(12)
        return (halfDeck + halfDeck).shuffled()
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
        cell.hidden = !cardVisibility[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as CardCell

        let card = deck[indexPath.row]
        cell.card = card
        if firstCard == nil {
            firstCard = cell
        } else if secondCard == nil {
            secondCard = cell
        } else {
            return
        }
        
        cell.show()
        numberOfTries++
        
        if firstCard != nil && secondCard != nil {
            if firstCard!.card == secondCard!.card {
                let delay = 1.0
                dispatch_after(
                    dispatch_time(
                        DISPATCH_TIME_NOW,
                        Int64(delay * Double(NSEC_PER_SEC))
                    ),
                    dispatch_get_main_queue(), {
                        self.numberOfPairs++
                        if self.numberOfPairs == self.deck.count()/2 {
                            var alert = UIAlertController(title: "Great!",
                                message: "You won in \(self.numberOfTries/2) tries!",
                                preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                                self.start()
                                return
                            }))
                                
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                        let index1 = self.collectionView!.indexPathForCell(self.firstCard!)!.row
                        let index2 = self.collectionView!.indexPathForCell(self.secondCard!)!.row
                        self.cardVisibility[index1] = false
                        self.cardVisibility[index2] = false
                        self.firstCard = nil
                        self.secondCard = nil
                        self.collectionView!.reloadData()
                })

            } else {
            
            
            let delay = 2.0
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(delay * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(), {
                    self.firstCard?.hide()
                    self.secondCard?.hide()
                    self.firstCard = nil
                    self.secondCard = nil
            })
            }
        }
        
    }
}

