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

class MemoryViewController: UIViewController {
    private var collectionView: UICollectionView?
    private var cards = Array<LayoutPlace>()
    
    private var selectedIndexes = Array<NSIndexPath>()
    
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
    
    deinit{
        println("deinit")
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
}

extension MemoryViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as CardCell
        
        let cardCellModel = cards[indexPath.row]
        cell.renderCardName(cardCellModel.card.description, backImageName: "back")
        cell.hidden = cardCellModel.empty
        
        return cell
    }
}

extension MemoryViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if selectedIndexes.count == 2 || contains(selectedIndexes, indexPath) {
            return
        }
        selectedIndexes.append(indexPath)
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as CardCell
        cell.upturn()
        
        if selectedIndexes.count < 2 {
            return
        }
        numberOfGuesses++
        
        let card1 = cards[selectedIndexes[0].row].card
        let card2 = cards[selectedIndexes[1].row].card
        
        if card1 == card2 {
            checkIfFinished()
            removeCards()
        } else {
            turnCardsFaceDown()
        }
    }
}

// MARK: Actions
private extension MemoryViewController {
    func checkIfFinished(){
        self.numberOfPairs++
        if self.numberOfPairs == self.cards.count/2 {
            showFinalPopUp()
        }
    }
    
    
    func showFinalPopUp() {
        var alert = UIAlertController(title: "Great!",
            message: "You won in \(numberOfGuesses) guesses!",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func removeCards(){
        execAfter(1.0) {
            self.removeCardsAtPlaces(self.selectedIndexes)
            self.selectedIndexes = Array<NSIndexPath>()
        }
    }
    
    func turnCardsFaceDown(){
        execAfter(2.0) {
            self.downturnCardsAtPlaces(self.selectedIndexes)
            self.selectedIndexes = Array<NSIndexPath>()
        }
    }
    
    func removeCardsAtPlaces(places: Array<NSIndexPath>){
        for index in selectedIndexes {
            let cardCell = collectionView!.cellForItemAtIndexPath(index) as CardCell
            cardCell.remove()
        }
    }
    
    func downturnCardsAtPlaces(places: Array<NSIndexPath>){
        for index in selectedIndexes {
            let cardCell = collectionView!.cellForItemAtIndexPath(index) as CardCell
            cardCell.downturn()
        }
    }
}

// MARK: Difficulty
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

// MARK: Setup
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

