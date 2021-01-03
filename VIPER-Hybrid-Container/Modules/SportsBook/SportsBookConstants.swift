//
//  Constants.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 26/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import Foundation
import UIKit

extension Constants {
    
    enum Playbook {
        enum Values { 
            static let rowHeight = CGFloat(106.0)     //the match cell row height
            //ALL TIMES IN SECONDS
            static let fakeUpdatesTimerInterval = Double(1) // how ofter we send and mainly receive a fake update via the socket server
            static let liveSecondsTimerInterval = Double(1)   //can play with time :)
            static let newBetIntroAnimTime = Double(0.5)    //on new bet the time it takes for the intro anim to happen
            static let newBetOutroAnimTime = Double(0.5)    //on new bet the time it takes for the intro anim to happen
            static let newBetOutroDelayTime = Double(2)   //after delay of which the text transitions back
        }
        
        enum Colors {
            static let screenBGColor = UIColor.init(red: 48/255, green: 53/255, blue: 64/255, alpha: 1)//darkgrey
            static let cellBGColorDark = UIColor.init(red: 32/255, green: 39/255, blue: 53/255, alpha: 1)//darkergrey
            static let cellBGColorLight = UIColor.white
            static let cellBetBGColorDark = UIColor.init(red: 65/255, green: 72/255, blue: 86/255, alpha: 1)//grey
            static let cellBetBGColorLight = UIColor.init(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)//light grey
            static let cellBetLabelDark = UIColor.white
            static let cellBetLabelLight = cellAwayLabelLight
            static let cellBetValueDark = UIColor.init(red: 109/255, green: 246/255, blue: 255/255, alpha: 1)//light blue
            static let cellBetValueLight = UIColor.black
            static let cellBetNewValueDark = UIColor.init(red: 240/255, green: 174/255, blue: 35/255, alpha: 1)//orange
            static let cellBetNewValueLight = cellBetNewValueDark
            static let cellTimeLabel = UIColor.init(red: 167/255, green: 176/255, blue: 185/255, alpha: 1) //grey
            static let cellDateLabel = UIColor.init(red: 130/255, green: 130/255, blue: 130/255, alpha: 1) //drker grey
            static let cellAwayLabelDark = UIColor.init(red: 167/255, green: 176/255, blue: 185/255, alpha: 1)
            static let cellAwayLabelLight = UIColor.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)//darkest grey
            static let cellHomeLabelDark = cellAwayLabelDark
            static let cellHomeLabelLight = cellAwayLabelLight
            static let cellHomeGoalsLabelDark = UIColor.white
            static let cellHomeGoalsLabelLight = cellAwayLabelLight
            static let cellAwayGoalsLabelDark = UIColor.white
            static let cellAwayGoalsLabelLight = cellAwayLabelLight
        }
    }
}
