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

struct LayoutPlace {
    let index: Int
    let card: Card
    var empty: Bool
}




import UIKit

class MemoryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private var collectionView: UICollectionView?
    private var cards = Array<LayoutPlace>()
    
    private var firstCard: LayoutPlace?
    private var secondCard: LayoutPlace?
    
    private var numberOfPairs = 0
    private var numberOfGuesses = 0
    private var difficulty = Difficulty.Easy
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        start()
    }
    
    private func start() {
        numberOfPairs = 0
        numberOfGuesses = 0
        
        for (index, card) in enumerate(createDeck()) {
            cards.append(LayoutPlace(index: index, card: card, empty: false))
        }
        collectionView!.reloadData()
    }
    
    private func createDeck() -> Deck {
        let fullDeck = Deck.full().shuffled()
        let halfDeck = fullDeck.deckOfNumberOfCards(numCardsNeededDifficulty(difficulty))
        return (halfDeck + halfDeck).shuffled()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as CardCell
//        cell.backgroundColor = UIColor.clearColor()
        
        let cardCellModel = cards[indexPath.row]
        cell.renderCardName(cardCellModel.card.description, backImageName: "back")
        cell.hidden = cardCellModel.empty
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as CardCell
        
        let cardCellModel = cards[indexPath.row]
        if firstCard == nil {
            firstCard = cardCellModel
        } else if secondCard == nil {
            secondCard = cardCellModel
        } else {
            return
        }
        cell.upturn()
        
        
        //        cardCellModel.covered = false
//        self.collectionView!.reloadData()
        

        if secondCard == nil {
            return
        }
        numberOfGuesses++
        
        if firstCard!.card == secondCard!.card {
            let delay = 1.0
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(delay * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(), {
                    self.numberOfPairs++
                    if self.numberOfPairs == self.cards.count/2 {
                        var alert = UIAlertController(title: "Great!",
                            message: "You won in \(self.numberOfGuesses) guesses!",
                            preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                            self.dismissViewControllerAnimated(true, completion: nil)
                            return
                        }))
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    self.removeCardsAtPlaces((self.firstCard!, self.secondCard!))
                    self.firstCard = nil
                    self.secondCard = nil
//                    self.collectionView!.reloadData()
            })
            
        } else {
            
            
            let delay = 2.0
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(delay * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(), {
                    self.downturnCardsAtPlaces((self.firstCard!, self.secondCard!))
                    self.firstCard = nil
                    self.secondCard = nil
//                    self.collectionView!.reloadData()
            })
        }
    }
    
    deinit{
        println("deinit")
    }
    
    func removeCardsAtPlaces(places: (LayoutPlace, LayoutPlace)){
        let cardCell1 = collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: places.0.index, inSection: 0)) as CardCell
        let cardCell2 = collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: places.1.index, inSection: 0)) as CardCell
        
        cardCell1.remove()
        cardCell2.remove()        
    }
    
    func downturnCardsAtPlaces(places: (LayoutPlace, LayoutPlace)){
        let cardCell1 = collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: places.0.index, inSection: 0)) as CardCell
        let cardCell2 = collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: places.1.index, inSection: 0)) as CardCell
        
        cardCell1.downturn()
        cardCell2.downturn()
    }
    
}

private extension MemoryViewController {
    func sizeDifficulty(difficulty: Difficulty) -> (CGFloat, CGFloat) {
        switch difficulty {
        case .Easy:
            return (4,3)
        case .Medium:
            return (6,4)
        case .Hard:
            return (8,4)
        }
    }
    
    func numCardsNeededDifficulty(difficulty: Difficulty) -> Int {
        let (columns, rows) = sizeDifficulty(difficulty)
        return Int(columns * rows / 2)
    }
}

private extension MemoryViewController {
    func setup() {
        view.backgroundColor = UIColor.greenSea()
        
        let (columns, rows) = sizeDifficulty(difficulty)
        
        let ratio: CGFloat = 1.452
        let space: CGFloat = 5
        
        let cardHeight: CGFloat = view.frame.height/rows - 2*space
        let cardWidth: CGFloat = cardHeight/ratio
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.itemSize = CGSize(width: cardWidth, height: cardHeight)
        layout.minimumLineSpacing = space
        
        
        let width = columns*(cardWidth + 2*space)
        let height = rows*(cardHeight + space)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        collectionView!.center = view.center
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.scrollEnabled = false
        collectionView!.registerClass(CardCell.self, forCellWithReuseIdentifier: "cardCell")
        collectionView!.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(collectionView!)
    }
}

