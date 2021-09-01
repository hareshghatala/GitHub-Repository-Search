//
//  GitHubRepositoriesViewController.swift
//  GitHub Repository Search
//
//  Created by Haresh Ghatala on 2021/09/01.
//

import UIKit

class GitHubRepositoriesViewController: UIViewController {

    @IBOutlet weak var mainSearchBar: UISearchBar!
    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
            mainTableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var searchInfoLabel: UILabel!
    @IBOutlet weak var searchHistoryTableView: UITableView! {
        didSet {
            searchHistoryTableView.layer.cornerRadius = 15
            searchHistoryTableView.layer.borderColor = UIColor.lightGray.cgColor
            searchHistoryTableView.layer.borderWidth = 0.5
            searchHistoryTableView.tableFooterView = UIView()
        }
    }
    
    private var selectedRepoItem: RepoItem?
    
    let viewModel = GitHubRepositoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bindRepoDataToController = { wipeData in
            self.dataBindingHandler(wipeData: wipeData)
        }
        viewModel.serviceFailur = {
            self.searchInfoLabel.isHidden = !self.viewModel.repoList.isEmpty
            self.mainTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedRepoItem = nil
    }
    
    private func dataBindingHandler(wipeData: Bool) {
        if wipeData {
            if !mainTableView.visibleCells.isEmpty {
                mainTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
            }
        }
        searchInfoLabel.isHidden = !viewModel.repoList.isEmpty
        mainTableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case repoDetailsSegueId:
            let repoDetailsScreen = segue.destination as! RepositoryDetailsViewController
            repoDetailsScreen.repoItem = selectedRepoItem
        default:
            break
        }
    }

}

// MARK: - SearchBar Delegate methods

extension GitHubRepositoriesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = true
        searchBar.isSearchResultsButtonSelected = true
        searchHistoryTableView.isHidden = false
        viewModel.fetchSearchHistory()
        searchHistoryTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.isSearchResultsButtonSelected = false
        self.view.endEditing(true)
        performSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    private func performSearch() {
        guard let text = mainSearchBar.text, !text.isEmpty else {
            return
        }
        searchHistoryTableView.isHidden = true
        viewModel.searchOffset = 1
        viewModel.fetchRepoItems(searchText: text, offset: viewModel.searchOffset)
    }
    
}

// MARK: - TableView DataSource & Delegate methods

extension GitHubRepositoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTableView {
            return viewModel.repoList.count
        } else {
            return viewModel.searchHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if tableView === mainTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: repoItemCellId, for: indexPath) as! RepoItemTableViewCell
            cell.cellData = viewModel.repoList[indexPath.row]
            return cell
            
        } else {
            
            if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: searchHistoryCellId) {
                cell = dequeueCell
            } else {
                cell = UITableViewCell(style: .default, reuseIdentifier: searchHistoryCellId)
            }
            cell.backgroundColor = .clear
            cell.textLabel?.text = viewModel.searchHistory[indexPath.row]
        }
        
        return cell
    }
    
}

extension GitHubRepositoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == mainTableView {
            if indexPath.row == viewModel.repoList.count - 1 {
                guard let text = mainSearchBar.text, !text.isEmpty else {
                    return
                }
                viewModel.fetchRepoItems(searchText: text, offset: viewModel.searchOffset)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == mainTableView {
            selectedRepoItem = viewModel.repoList[indexPath.row]
            performSegue(withIdentifier: repoDetailsSegueId, sender: self)
        } else {
            mainSearchBar.text = viewModel.searchHistory[indexPath.row]
            self.view.endEditing(true)
            performSearch()
        }
        
    }
    
}
