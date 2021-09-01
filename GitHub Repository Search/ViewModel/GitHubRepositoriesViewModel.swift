//
//  GitHubRepositoriesViewModel.swift
//  GitHub Repository Search
//
//  Created by Haresh Ghatala on 2021/09/01.
//

import Foundation

class GitHubRepositoriesViewModel {
    
    private var searchData: RepoSearchData?
    
    private(set) var repoList: [RepoItem] = []
    private(set) var searchHistory: [String] = []
    
    var serviceSession = Service.shared
    var bindRepoDataToController: ((Bool) -> ()) = { wipeData in }
    var serviceFailur: (() -> ()) = { }
    var searchOffset = 1
    
    init() {
        fetchSearchHistory()
    }
    
    // MARK: -  Network calls
    
    func isOffsetExceeded(offset: Int) -> Bool {
        if offset > maxPageLimit ||
            ((offset - 1) * apiDataLimit) > (searchData?.totalCount ?? 0) {
            return true
        }
        return false
    }
    
    func fetchRepoItems(searchText: String, offset: Int) {
        print("Searching Offset: \(offset)")
        if (offset != 1 && isOffsetExceeded(offset: offset)) ||
            searchText.isEmpty {
            return
        }
        
        ProgressHUD.show(interaction: false)
        insertSearchHistory(text: searchText.capitalized)
        
        serviceSession.SearchRepositories(searchText: searchText, offset: offset) { (result: Result<RepoSearchData, ServiceError>) in
            switch result {
            case .success(let searchList):
                self.handleSuccess(response: searchList, wipeData: (offset == 1))
                
            case .failure(let error):
                self.handleFailure(error: error)
            }
            ProgressHUD.dismiss()
        }
    }
    
    private func handleSuccess(response: RepoSearchData, wipeData: Bool = false) {
        searchData = response
        guard let repoItems = searchData?.items else {
            return
        }
        
        if wipeData {
            repoList.removeAll()
        }
        repoList.append(contentsOf: repoItems)
        print("Response: Page-\(searchOffset) TotalPages-\(searchData?.totalCount ?? 0)")
        searchOffset += 1
        updateRepoDataToView(wipeData: wipeData)
    }
    
    private func handleFailure(error: ServiceError) {
        serviceFailurToView()
        switch error {
        case .invalidEndpoint:
            ProgressHUD.show(errorMsgInvalidEndpoint, icon: .failed, interaction: true)
        case .invalidResponse, .decodeError:
            ProgressHUD.show(errorMsgInvalidResponse, icon: .failed, interaction: true)
        default:
            ProgressHUD.show(errorMsgUnknown, icon: .failed, interaction: true)
        }
    }
    
    // MARK: - Helper methods
    
    func fetchSearchHistory() {
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let plistPath = docPath.appendingPathComponent(searchHistoryPlistFile).path
        
        guard let xml = FileManager.default.contents(atPath: plistPath),
              let history = try? PropertyListDecoder().decode([String].self, from: xml) else {
            return
        }
        searchHistory = history
    }
    
    func saveSearchHistory() {
        var plistPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        plistPath.appendPathComponent(searchHistoryPlistFile)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        do {
            let data = try encoder.encode(searchHistory)
            try data.write(to: plistPath)
        } catch {
            print(error)
        }
        
    }
    
    // MARK: -  Private methods
    
    private func updateRepoDataToView(wipeData: Bool) {
        DispatchQueue.main.async {
            self.bindRepoDataToController(wipeData)
        }
    }
    
    private func serviceFailurToView() {
        DispatchQueue.main.async {
            self.serviceFailur()
        }
    }
    
    private func insertSearchHistory(text: String) {
        if let indx = searchHistory.firstIndex(of: text) {
            searchHistory.remove(at: indx)
        }
        searchHistory.insert(text, at: 0)
        
        if searchHistory.count > searchHistoryLimit {
            searchHistory.removeLast()
        }
        saveSearchHistory()
    }
    
}
