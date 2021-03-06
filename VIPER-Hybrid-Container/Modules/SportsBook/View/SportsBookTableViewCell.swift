//
//  SportsBookTableViewCell.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import CoreFoundation

import UIKit
import Kingfisher

class SportsBookTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!

    @IBOutlet weak var homeGoalsLabel: UILabel!
    @IBOutlet weak var awayGoalsLabel: UILabel!

    @IBOutlet weak var bet1: UILabel!
    @IBOutlet weak var betX: UILabel!
    @IBOutlet weak var bet2: UILabel!

    @IBOutlet weak var bet1Label: UILabel!
    @IBOutlet weak var betXLabel: UILabel!
    @IBOutlet weak var bet2Label: UILabel!

    @IBOutlet weak var betBackground1: UIView!
    @IBOutlet weak var betBackground2: UIView!
    @IBOutlet weak var betBackground3: UIView!

    @IBOutlet weak var cellBackground: UIView!

    func displayTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60

        return ((mins > 9) ? "\(mins)" : "0\(mins)") + ":" + ((secs > 9) ? "\(secs)" : "0\(secs)")
    }

    var isLive = false

    func setup(_ match: Match, _ indexPath: IndexPath) {

        self.backgroundColor = Constants.Playbook.Colors.screenBGColor

        if match.live == 1 {
            isLive = true

            self.cellBackground.backgroundColor = Constants.Playbook.Colors.cellBGColorDark
            self.betBackground1.backgroundColor = Constants.Playbook.Colors.cellBetBGColorDark
            self.betBackground2.backgroundColor = Constants.Playbook.Colors.cellBetBGColorDark
            self.betBackground3.backgroundColor = Constants.Playbook.Colors.cellBetBGColorDark

            self.dateTimeLabel.textColor = Constants.Playbook.Colors.cellTimeLabel

            self.homeLabel.textColor = Constants.Playbook.Colors.cellHomeLabelDark
            self.awayLabel.textColor = Constants.Playbook.Colors.cellAwayLabelDark
            self.bet1Label.textColor = Constants.Playbook.Colors.cellBetLabelDark
            self.betXLabel.textColor = Constants.Playbook.Colors.cellBetLabelDark
            self.bet2Label.textColor = Constants.Playbook.Colors.cellBetLabelDark
            self.homeGoalsLabel.textColor = Constants.Playbook.Colors.cellHomeGoalsLabelDark
            self.awayGoalsLabel.textColor = Constants.Playbook.Colors.cellAwayGoalsLabelDark
            self.bet1.textColor = Constants.Playbook.Colors.cellBetValueDark
            self.betX.textColor = Constants.Playbook.Colors.cellBetValueDark
            self.bet2.textColor = Constants.Playbook.Colors.cellBetValueDark

            self.dateTimeLabel.text = displayTime(match.time)
        } else {
            isLive = false
            self.cellBackground.backgroundColor = Constants.Playbook.Colors.cellBGColorLight
            self.betBackground1.backgroundColor = Constants.Playbook.Colors.cellBetBGColorLight
            self.betBackground2.backgroundColor = Constants.Playbook.Colors.cellBetBGColorLight
            self.betBackground3.backgroundColor = Constants.Playbook.Colors.cellBetBGColorLight

            self.dateTimeLabel.textColor = Constants.Playbook.Colors.cellDateLabel

            self.homeLabel.textColor = Constants.Playbook.Colors.cellHomeLabelLight
            self.awayLabel.textColor = Constants.Playbook.Colors.cellAwayLabelLight
            self.bet1Label.textColor = Constants.Playbook.Colors.cellBetLabelLight
            self.betXLabel.textColor = Constants.Playbook.Colors.cellBetLabelLight
            self.bet2Label.textColor = Constants.Playbook.Colors.cellBetLabelLight
            self.homeGoalsLabel.textColor = Constants.Playbook.Colors.cellHomeGoalsLabelLight
            self.awayGoalsLabel.textColor = Constants.Playbook.Colors.cellAwayGoalsLabelLight
            self.bet1.textColor = Constants.Playbook.Colors.cellBetValueLight
            self.betX.textColor = Constants.Playbook.Colors.cellBetValueLight
            self.bet2.textColor = Constants.Playbook.Colors.cellBetValueLight

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
        bet1.text = String(format: "%.02f", Double(match.bet1) / 100.0)
        betX.text = String(format: "%.02f", Double(match.betX) / 100.0)
        bet2.text = String(format: "%.02f", Double(match.bet2) / 100.0)
    }

    func displayUpdatedTime(matchTime: Int) {
        self.dateTimeLabel.text = displayTime(matchTime)
    }

    func animateLabelColorOnNewValue(updatedMatch: MatchUpdate) {

        let labelToAnimate: UILabel

        switch updatedMatch.updateFor {
        case .home:
            bet1.text = String(format: "%.02f", Double(updatedMatch.value) / 100.0)
            labelToAnimate = bet1
        case .draw:
            betX.text = String(format: "%.02f", Double(updatedMatch.value) / 100.0)
            labelToAnimate = betX
        case .away:
            bet2.text = String(format: "%.02f", Double(updatedMatch.value) / 100.0)
            labelToAnimate = bet2
        }

        if self.isLive {
            labelToAnimate.textColor = Constants.Playbook.Colors.cellBetValueDark
        } else {
            labelToAnimate.textColor = Constants.Playbook.Colors.cellBetValueLight
        }

        UIView.transition(with: labelToAnimate,
                          duration: Constants.Playbook.Values.newBetIntroAnimTime,
                          options: .transitionFlipFromTop,
                          animations: {
                            labelToAnimate.textColor = Constants.Playbook.Colors.cellBetNewValueDark
                          },
                          completion: { finished in
                            if finished {
                                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Playbook.Values.newBetOutroDelayTime,
                                                              execute: { [weak self] in

                                    guard self != nil else { return }

                                    UIView.transition(with: labelToAnimate,
                                                      duration: Constants.Playbook.Values.newBetOutroAnimTime,
                                                      options: .transitionCrossDissolve, animations: {
                                                        labelToAnimate.textColor = Constants.Playbook.Colors.cellBetValueDark
                                                      }, completion: { finished in
                                                        if finished {
                                                            guard self != nil else { return }

                                                            if self!.isLive {
                                                                labelToAnimate.textColor = Constants.Playbook.Colors.cellBetValueDark
                                                            } else {
                                                                labelToAnimate.textColor = Constants.Playbook.Colors.cellBetValueLight
                                                            }
                                                        }
                                                    })
                                })
                            }
        })
    }
}
