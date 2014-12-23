//
//  Deck.swift
//  Memory
//
//  Created by Giordano Scalzo on 19/11/2014.
//  Copyright (c) 2014 Swift by Example. All rights reserved.
//
import Foundation

enum Rank: Int, Printable {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    var description: String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

enum Suit: Printable {
    case Spades, Hearts, Diamonds, Clubs
    var description: String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
}

struct Card: Printable, Equatable {
    private let rank: Rank
    private let suit: Suit
    
    var description: String {
        return "\(rank.description)_of_\(suit.description)"
    }
}
func ==(card1: Card, card2: Card) -> Bool {
    return card1.rank == card2.rank && card1.suit == card2.suit
}

struct Deck {
    private var cards = [Card]()
    
    static func full() -> Deck {
        var deck = Deck()
        for i in Rank.Ace.rawValue...Rank.King.rawValue {
            for suit in [Suit.Spades, .Hearts, .Clubs, .Diamonds] {
                let card = Card(rank: Rank(rawValue: i)!, suit: suit)
                deck.append(card)
            }
        }
        return deck
    }

    func deckOfNumberOfCards(num: Int) -> Deck {
        var newDeck = Deck()
        for i in 0..<num {
            newDeck.append(self[i])
        }
        return newDeck
    }
    
    // Fisher-Yates (fast and uniform) shuffle
    func shuffled() -> Deck {
        var list = cards
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            swap(&list[i], &list[j])
        }
        return Deck(cards: list)
    }
}

extension Deck: SequenceType {
    func generate() -> GeneratorOf<Card> {
        var i = 0
        return GeneratorOf<Card> {
            return i >= self.cards.count ? .None : self.cards[i++]
        }
    }
}

private extension Deck {
    private mutating func append(card: Card) {
        cards.append(card)
    }
    private subscript(index: Int) -> Card {
        get {
            return cards[index]
        }
    }
}

func +(deck1: Deck, deck2: Deck) -> Deck {
    var result = deck1
    for card in deck2 {
        result.append(card)
    }
    return result
}
