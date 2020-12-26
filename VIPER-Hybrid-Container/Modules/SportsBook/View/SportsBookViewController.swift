//
//  SportsBookViewController.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 23/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class SportsBookViewController: UIViewController {
    
    @IBOutlet weak var matchesTableView: UITableView!
    
    var presenter: SportsBookPresentation!
    
    var liveMatches: [Match] = []
//{
//        didSet {
////moved bellow for finer control, updateSportsBookData will reload only single rows
////            matchesTableView.reloadData()
//        }
//    }
    
    var futureMatches: [Match] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear(animated)
    }

    
    fileprivate func setupView() {
        
        navigationItem.title = Localization.Playbook.navigationBarTitle
        
        matchesTableView.backgroundColor = UIColor.black
        matchesTableView.dataSource = self
        matchesTableView.delegate = self
        matchesTableView.rowHeight = UITableViewAutomaticDimension
        matchesTableView.estimatedRowHeight = 106.0
        matchesTableView.register(SportsBookTableViewCell.self)
    }
}

extension SportsBookViewController: SportsBookView {

    func showSportsBookData(_ liveMatches: [Match], _ futureMatches: [Match]) {
        self.liveMatches = liveMatches
        self.futureMatches = futureMatches
        
        matchesTableView.reloadData()
    }
    
    func updateSportsBookData(withMatch match:Match, updatedMatch:MatchUpdate, andIndex index:Int) {
        
        liveMatches[index] = match
        
        //matchesTableView.reloadData()
        
        //better: find the cell if visible and update it
        let indexPath = IndexPath(row: index, section: 0)

        if let paths = matchesTableView.indexPathsForVisibleRows , paths.contains(indexPath) {
            if let cell = matchesTableView.cellForRow(at: indexPath) as! SportsBookTableViewCell? {
//                cell.setup(match, indexPath)
                cell.animateLabelColorOnNewValue(updatedMatch: updatedMatch)
            }
        }
    }
    
    func updateLiveMatchesWithNewTimes(_ liveMatches: [Match]) {
        self.liveMatches = liveMatches
        
        for (index, match) in self.liveMatches.enumerated() {

            let indexPath = IndexPath(row: index, section: 0)
            //if the match is visible update it
            if let paths = matchesTableView.indexPathsForVisibleRows , paths.contains(indexPath) {
                if let cell = matchesTableView.cellForRow(at: indexPath) as! SportsBookTableViewCell? {
                    cell.displayUpdatedTime(matchTime: match.time)
                }
            } else {
                print("Skipping update not visible \(indexPath.row)") ;
            }
        }
    }
}

extension SportsBookViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let one = liveMatches.count > 0 ? 1 : 0
        let two = futureMatches.count > 0 ? 1 : 0

        return one + two
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return liveMatches.count
        } else {
            return futureMatches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SportsBookTableViewCell
        
        let match:Match
        
        if (indexPath.section == 0) {
            match = liveMatches[indexPath.row]
        } else {
            match = futureMatches[indexPath.row]
        }
        
        cell.selectionStyle = .none
        cell.setup(match, indexPath)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return .leastNormalMagnitude
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return .leastNormalMagnitude //8
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter.didSelectMatch(matches[indexPath.section])
//    }
}
