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
    
    var matches: [Match] = [] {
        didSet {
//moved bellow for finer control, updateSportsBookData will reload only single rows
//            matchesTableView.reloadData()
        }
    }
    
    
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
        
        matchesTableView.dataSource = self
        matchesTableView.delegate = self
        matchesTableView.rowHeight = UITableViewAutomaticDimension
        matchesTableView.estimatedRowHeight = 88.0
        matchesTableView.register(SportsBookTableViewCell.self)
    }
}

extension SportsBookViewController: SportsBookView {
    
    func showSportsBookData(_ matches: [Match]) {
        self.matches = matches
        matchesTableView.reloadData()
    }
    
    func updateSportsBookData(withMatch match:Match, updatedMatch:MatchUpdate, andIndex index:Int) {
        
        matches[index] = match
        
        //matchesTableView.reloadData()
        
        //TODO: Update only changed row
        let indexPath = IndexPath(row: index, section: 0)
//        UIView.setAnimationsEnabled(false)
//        matchesTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
//        UIView.setAnimationsEnabled(true)
        
        //better: find the cell if visible and update it
        if let paths = matchesTableView.indexPathsForVisibleRows , paths.contains(indexPath) {
            if let cell = matchesTableView.cellForRow(at: indexPath) as! SportsBookTableViewCell? {
                cell.setup(match, indexPath)
                cell.animateLabelColorOnNewValue(updateFor: updatedMatch.updateFor)
            }
        }
    }
}

extension SportsBookViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SportsBookTableViewCell
        let match = matches[indexPath.row]
        
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
