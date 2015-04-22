//
//  ViewController.swift
//  Memory
//
//  Created by Giordano Scalzo on 22/12/2014.
//  Copyright (c) 2014 Swift by Example. All rights reserved.
//

import UIKit

enum Difficulty {
    case Easy, Medium, Hard
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension ViewController {
    func setup() {
        view.backgroundColor = UIColor.greenSea()
        
        buildButtonWithCenter(CGPoint(x: view.center.x, y: view.center.y/2.0),
            title: "EASY", color: UIColor.emerald(), action: "onEasyTapped:")
        buildButtonWithCenter(CGPoint(x: view.center.x, y: view.center.y),
            title: "MEDIUM", color: UIColor.sunflower(), action: "onMediumTapped:")
        buildButtonWithCenter(CGPoint(x: view.center.x, y: view.center.y*3.0/2.0),
            title: "HARD", color: UIColor.alizarin(), action: "onHardTapped:")
    }

    func buildButtonWithCenter(center: CGPoint, title: String, color: UIColor, action: Selector) {
        let button = UIButton()
        button.setTitle(title, forState: .Normal)
        
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 50))
        button.center = center
        button.backgroundColor = color
        
        button.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
    }
}

extension ViewController {
    func onEasyTapped(sender: UIButton) {
        newGameDifficulty(.Easy)
    }
    
    func onMediumTapped(sender: UIButton) {
        newGameDifficulty(.Medium)
    }
    
    func onHardTapped(sender: UIButton) {
        newGameDifficulty(.Hard)
    }
    
    func newGameDifficulty(difficulty: Difficulty) {
        switch difficulty {
        case .Easy:
            println("Easy")
        case .Medium:
            println("Medium")
        case .Hard:
            println("Hard")
        }    }
}