//
//  RepositoryDetailsViewController.swift
//  GitHub Repository Search
//
//  Created by Haresh Ghatala on 2021/09/01.
//

import UIKit
import WebKit

class RepositoryDetailsViewController: UIViewController {

    @IBOutlet weak var mainWebView: WKWebView!
    
    var repoItem: RepoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        guard let pageUrl = repoItem.htmlUrl else {
            return
        }
        mainWebView.load(URLRequest(url: URL(string: pageUrl)!,
                                    cachePolicy: .returnCacheDataElseLoad,
                                    timeoutInterval: 120.0))
    }

}
