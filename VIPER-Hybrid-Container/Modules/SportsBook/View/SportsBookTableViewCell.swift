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
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!
    
    @IBOutlet weak var homeGoalsLabel: UILabel!
    @IBOutlet weak var awayGoalsLabel: UILabel!
    
    @IBOutlet weak var bet_1: UILabel!
    @IBOutlet weak var bet_x: UILabel!
    @IBOutlet weak var bet_2: UILabel!
    
    @IBOutlet weak var bet1Label: UILabel!
    @IBOutlet weak var betXLabel: UILabel!
    @IBOutlet weak var bet2Label: UILabel!

    
    @IBOutlet weak var betBackground1: UIView!
    @IBOutlet weak var betBackground2: UIView!
    @IBOutlet weak var betBackground3: UIView!
    
    @IBOutlet weak var cellBackground: UIView!
    
    func displayTime(_ seconds:Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60

        return ((mins > 9) ? "\(mins)" : "0\(mins)") + ":" + ((secs > 9) ? "\(secs)" : "0\(secs)")
    }
    
    func setup(_ match: Match, _ indexPath: IndexPath) {
        
        if (match.live == 1) {
            self.backgroundColor = UIColor.black
            self.cellBackground.backgroundColor = UIColor(red: 23/255, green: 33/255, blue: 37/255, alpha: 1)
            self.betBackground1.backgroundColor = UIColor.black
            self.betBackground2.backgroundColor = UIColor.black
            self.betBackground3.backgroundColor = UIColor.black
            
            self.dateTimeLabel.textColor = UIColor.white
            self.homeLabel.textColor = UIColor.white
            self.awayLabel.textColor = UIColor.white
            self.bet1Label.textColor = UIColor.white
            self.betXLabel.textColor = UIColor.white
            self.bet2Label.textColor = UIColor.white
            self.homeGoalsLabel.textColor = UIColor.yellow
            self.awayGoalsLabel.textColor = UIColor.yellow
            self.bet_1.textColor = UIColor.yellow
            self.bet_x.textColor = UIColor.yellow
            self.bet_2.textColor = UIColor.yellow

            self.dateTimeLabel.text = displayTime(match.time)
        } else {
            self.backgroundColor = UIColor.lightGray
            self.cellBackground.backgroundColor = UIColor.white
            self.betBackground1.backgroundColor = UIColor.lightGray
            self.betBackground2.backgroundColor = UIColor.lightGray
            self.betBackground3.backgroundColor = UIColor.lightGray
            
            self.dateTimeLabel.textColor = UIColor.black
            self.homeLabel.textColor = UIColor.black
            self.awayLabel.textColor = UIColor.black
            self.bet1Label.textColor = UIColor.black
            self.betXLabel.textColor = UIColor.black
            self.bet2Label.textColor = UIColor.black
            self.homeGoalsLabel.textColor = UIColor.blue
            self.awayGoalsLabel.textColor = UIColor.blue
            self.bet_1.textColor = UIColor.blue
            self.bet_x.textColor = UIColor.blue
            self.bet_2.textColor = UIColor.blue

            self.dateTimeLabel.text = match.date
        }
        
//        if (indexPath.row % 2 == 0) {
//            self.backgroundColor = UIColor.gray
//        } else {
//            self.backgroundColor = UIColor.darkGray
//        }
        
        homeLabel.text = match.home
        awayLabel.text = match.away
        homeGoalsLabel.text = "\(match.homeGoals)"
        awayGoalsLabel.text = "\(match.awayGoals)"
        bet_1.text = String(format:"%.02f", Double(match.bet1) / 100.0)
        bet_x.text = String(format:"%.02f", Double(match.betX) / 100.0)
        bet_2.text = String(format:"%.02f", Double(match.bet2) / 100.0)
    }
    
    func displayUpdatedTime(matchTime: Int) {
        self.dateTimeLabel.text = displayTime(matchTime)
    }

    
    func animateLabelColorOnNewValue(updatedMatch:MatchUpdate) {
        
        let labelToAnimate:UILabel
        
        switch updatedMatch.updateFor {
        case .Home:
            bet_1.text = String(format:"%.02f", Double(updatedMatch.value) / 100.0)
            labelToAnimate = bet_1
        case .Draw:
            bet_x.text = String(format:"%.02f", Double(updatedMatch.value) / 100.0)
            labelToAnimate = bet_x
        case .Away:
            bet_2.text = String(format:"%.02f", Double(updatedMatch.value) / 100.0)
            labelToAnimate = bet_2
        }
        
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

