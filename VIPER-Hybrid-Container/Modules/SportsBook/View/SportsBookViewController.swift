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

    var futureMatches: [Match] = []

    var savedOrientationRawValue: Int = UIDeviceOrientation.unknown.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear(animated)

        //This is needed because after setting the orientation in viewWillAppear to
        //UIInterfaceOrientationMask.portrait.rawValue, forKey: "orientation")
        //while the phone is in landscape, bellow the value of UIDevice.current.orientation
        //is reported as portraitUpsideDown instead of landScapeLeft/Right
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {

            UIDevice.current.setValue(UIDevice.current.orientation.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        } else if savedOrientationRawValue != UIDeviceOrientation.portrait.rawValue {

            UIDevice.current.setValue(savedOrientationRawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        savedOrientationRawValue = UIDevice.current.orientation.rawValue

        UIDevice.current.setValue(UIInterfaceOrientationMask.portrait.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

    private func setupView() {

        navigationItem.title = Localization.Playbook.navigationBarTitle

        view.backgroundColor = Constants.Playbook.Colors.screenBGColor
        matchesTableView.backgroundColor = Constants.Playbook.Colors.screenBGColor
        matchesTableView.dataSource = self
        matchesTableView.delegate = self
        matchesTableView.rowHeight = UITableViewAutomaticDimension
        matchesTableView.estimatedRowHeight = Constants.Playbook.Values.rowHeight
        matchesTableView.register(SportsBookTableViewCell.self)
    }
}

extension SportsBookViewController: SportsBookView {

    func showSportsBookData(_ liveMatches: [Match], _ futureMatches: [Match]) {
        self.liveMatches = liveMatches
        self.futureMatches = futureMatches

        matchesTableView.reloadData()
    }

    func updateSportsBookData(withMatch match: Match, updatedMatch: MatchUpdate, andIndex index: Int) {

        liveMatches[index] = match

        //matchesTableView.reloadData()

        //better: find the cell if visible and update it
        let indexPath = IndexPath(row: index, section: 0)

        if let paths = matchesTableView.indexPathsForVisibleRows, paths.contains(indexPath) {
            if let cell = matchesTableView.cellForRow(at: indexPath) as? SportsBookTableViewCell {
//                cell.setup(match, indexPath)
                cell.animateLabelColorOnNewValue(updatedMatch: updatedMatch)
            }
        }
//        else
//        {
//            print("Skipping update not visible \(indexPath.row)") ;
//        }
    }

    func updateLiveMatchesWithNewTimes(_ liveMatches: [Match]) {
        self.liveMatches = liveMatches

        for (index, match) in self.liveMatches.enumerated() {

            let indexPath = IndexPath(row: index, section: 0)
            //if the match is visible update it
            if let paths = matchesTableView.indexPathsForVisibleRows, paths.contains(indexPath) {
                if let cell = matchesTableView.cellForRow(at: indexPath) as? SportsBookTableViewCell {
                    cell.displayUpdatedTime(matchTime: match.time)
                }
            }
//            } else {
//                print("Skipping update not visible \(indexPath.row)") ;
//            }
        }
    }
}

extension SportsBookViewController: RotatableView {
    func allowedOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

extension SportsBookViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {

        let one = liveMatches.count > 0 ? 1 : 0
        let two = futureMatches.count > 0 ? 1 : 0

        return one + two
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return liveMatches.count
        } else {
            return futureMatches.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SportsBookTableViewCell

        let match: Match

        if indexPath.section == 0 {
            match = liveMatches[indexPath.row]
        } else {
            match = futureMatches[indexPath.row]
        }

        cell.selectionStyle = .none
        cell.setup(match, indexPath)

        return cell
    }
}
