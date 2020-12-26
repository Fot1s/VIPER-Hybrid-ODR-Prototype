//
//  SportsBookTableViewCell.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//


import UIKit
import Kingfisher

class SportsBookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!
    
    
    @IBOutlet weak var bet_1: UILabel!
    @IBOutlet weak var bet_x: UILabel!
    @IBOutlet weak var bet_2: UILabel!
    
    func setup(_ match: Match, _ indexPath: IndexPath) {
        
        if (indexPath.row % 2 == 0) {
            self.backgroundColor = UIColor.gray
        } else {
            self.backgroundColor = UIColor.darkGray
        }
        
        homeLabel.text = match.home
        awayLabel.text = match.away
        bet_1.text = String(format:"%.02f", Double(match.bet1) / 100.0)
        bet_x.text = String(format:"%.02f", Double(match.betX) / 100.0)
        bet_2.text = String(format:"%.02f", Double(match.bet2) / 100.0)
    }
    
    func animateLabelColorOnNewValue(updateFor:MatchUpdate.UpdateFor) {
        
        let labelToAnimate:UILabel
        
        switch updateFor {
        case .Home:
            labelToAnimate = bet_1
        case .Draw:
            labelToAnimate = bet_x
        case .Away:
            labelToAnimate = bet_2
        }
        
//        labelToAnimate.layer.removeAllAnimations()
        labelToAnimate.textColor = UIColor.yellow
        
        UIView.transition(with: labelToAnimate, duration: 0.5, options: .transitionFlipFromTop, animations: {
            labelToAnimate.textColor = UIColor.green
        }, completion: { finished in
            if (finished) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    labelToAnimate.textColor = UIColor.yellow
                })
            }            
        })
    }
}

