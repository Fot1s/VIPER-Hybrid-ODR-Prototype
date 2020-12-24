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
    
    func setup(_ match: Match) {
        homeLabel.text = match.home
        awayLabel.text = match.away
        bet_1.text = "\(match.bet_1)"
        bet_x.text = "\(match.bet_x)"
        bet_2.text = "\(match.bet_2)"
    }
}

