//
//  ReactAppsViewController.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit

class ReactAppsViewController: UIViewController {
    
    @IBOutlet weak var reactAppsTableView: UITableView!
    
    var presenter: ReactAppsPresentation!

    var reactApps: [ReactApp] = [] {
        didSet {
            reactAppsTableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }

    fileprivate func setupView() {
        
        navigationItem.title = Localization.ReactApps.navigationBarTitle
        
        reactAppsTableView.dataSource = self
        reactAppsTableView.delegate = self
        reactAppsTableView.rowHeight = UITableViewAutomaticDimension
        reactAppsTableView.estimatedRowHeight = 230.0
        reactAppsTableView.register(ReactAppTableViewCell.self)
    }
}

extension ReactAppsViewController: ReactAppsView {
    
    func showReactAppsData(_ reactApps: [ReactApp]) {
        self.reactApps = reactApps
    }
}

extension ReactAppsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return reactApps.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ReactAppTableViewCell
        let reactApp = reactApps[indexPath.section]

        cell.selectionStyle = .none
        cell.setup(reactApp)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectReactApp(reactApps[indexPath.section])
    }
}

