//
//  HybridContentViewController.swift
//  VIPER-Hybrid-Container
//
//  Created by Fotis Chatzinikos on 13/12/2020.
//  Copyright © 2020 Fotis Chatzinikos. All rights reserved.
//

import UIKit
import WebKit

class HybridContentViewController: UIViewController {

    @IBOutlet weak var hybridContentWebView: WKWebView!

    var presenter: HybridContentPresentation!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        presenter.viewDidLoad()
    }

    private func setupView() {

        navigationItem.title = Localization.HybridContent.navigationBarTitle

        hybridContentWebView.navigationDelegate = self

    }
}

extension HybridContentViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideActivityIndicator()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityError(error.localizedDescription)
    }
}

extension HybridContentViewController: HybridContentView {
    func loadReactAppODRContentData(_ stringTag: String) {

        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: stringTag)!

        hybridContentWebView.loadFileURL(url, allowingReadAccessTo: url)
    }
}
