//
//  GitHubRepositoriesViewModelTests.swift
//  GitHub Repository SearchTests
//
//  Created by Haresh Ghatala on 2021/09/02.
//

import XCTest
@testable import GitHub_Repository_Search

class GitHubRepositoriesViewModelTests: XCTestCase {
    
    var mockService: MockService!
    
    var mockOwner: Owner!
    var mockRepoItem1: RepoItem!
    var mockRepoItem2: RepoItem!
    var mockRepoItem3: RepoItem!
    var mockRepoItems: [RepoItem]!
    var mockData: RepoSearchData!
    
    override func setUpWithError() throws {
        mockService = MockService.mockShared
        
        mockOwner = Owner(login: "Test Login Name", id: 223344, avatarUrl: "https://sample.com/test.jpg")
        mockRepoItem1 = RepoItem(id: 111, name: "Name-1",
                                 fullName: "FullName-1", isPrivate: false,
                                 owner: mockOwner, htmlUrl: "https://sample.com/test.html",
                                 description: "Sample Description-1", cloneUrl: "https://sample.com/test.git",
                                 size: 234545, language: "Swift", score: 1)
        mockRepoItem2 = RepoItem(id: 222, name: "Name-2",
                                 fullName: "FullName-2", isPrivate: false,
                                 owner: mockOwner, htmlUrl: "https://sample.com/test.html",
                                 description: "Sample Description-2", cloneUrl: "https://sample.com/test.git",
                                 size: 234545, language: "Objective-C", score: 2)
        mockRepoItem3 = RepoItem(id: 333, name: "Name-3",
                                 fullName: "FullName-3", isPrivate: false,
                                 owner: mockOwner, htmlUrl: "https://sample.com/test.html",
                                 description: "Sample Description-3", cloneUrl: "https://sample.com/test.git",
                                 size: 234545, language: "Java", score: 3)
        mockRepoItems = [mockRepoItem1, mockRepoItem2, mockRepoItem3]
        mockData = RepoSearchData(totalCount: 840, incompleteResults: false, items: mockRepoItems)
    }
    
    override func tearDownWithError() throws {
        mockService = nil
        mockOwner = nil
        mockRepoItem1 = nil
        mockRepoItem2 = nil
        mockRepoItem3 = nil
        mockRepoItems = nil
        mockData = nil
    }
    
    func testViewModelInitialsCorrectly() throws {
        mockService.isfailur = true
        mockService.mockServiceError = ServiceError.noData
        
        let obj = GitHubRepositoriesViewModel()
        obj.serviceSession = mockService
        XCTAssertNotNil(obj)
    }
    
    func testIsOffsetExceededForMaxPageLimit() throws {
        let obj = GitHubRepositoriesViewModel()
        
        XCTAssertTrue(obj.isOffsetExceeded(offset: 30))
    }
    
    func testIsOffsetExceededForTotalCountLimit() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GitHubRepositoriesViewModel()
        obj.serviceSession = mockService
        obj.fetchRepoItems(searchText: "Sample", offset: 1)
        
        XCTAssertTrue(obj.isOffsetExceeded(offset: 22))
    }
    
    func testIsOffsetExceededForWithinLimit() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GitHubRepositoriesViewModel()
        obj.serviceSession = mockService
        obj.fetchRepoItems(searchText: "Sample", offset: 1)
        
        XCTAssertFalse(obj.isOffsetExceeded(offset: 3))
    }
    
    func testFetchImagesRetrievesDataCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GitHubRepositoriesViewModel()
        obj.serviceSession = mockService
        
        obj.fetchRepoItems(searchText: "Sample", offset: 1)
        
        XCTAssertEqual(obj.repoList, mockRepoItems)
        XCTAssertEqual(obj.repoList.count, 3)
        XCTAssertEqual(obj.searchOffset, 2)
        XCTAssertEqual(obj.searchHistory[0], "Sample")
    }
    
    func testFetchImagesPaginationHandledCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GitHubRepositoriesViewModel()
        obj.serviceSession = mockService
        
        obj.fetchRepoItems(searchText: "Sample", offset: 1)
        obj.fetchRepoItems(searchText: "Sample", offset: 2)
        
        XCTAssertEqual(obj.repoList.count, 6)
        XCTAssertEqual(obj.searchOffset, 3)
        XCTAssertEqual(obj.searchHistory[0], "Sample")
    }
    
    func testFetchImagesOverPaginationHandledCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GitHubRepositoriesViewModel()
        obj.serviceSession = mockService
        
        obj.fetchRepoItems(searchText: "Sample", offset: 1)
        obj.fetchRepoItems(searchText: "Sample", offset: 2)
        
        XCTAssertEqual(obj.repoList.count, 6)
        XCTAssertEqual(obj.searchOffset, 3)
        
        obj.fetchRepoItems(searchText: "Sample", offset: 1231)
        XCTAssertEqual(obj.repoList.count, 6)
        XCTAssertEqual(obj.searchOffset, 3)
        XCTAssertEqual(obj.searchHistory[0], "Sample")
    }
    
    func testFetchImagesFailureHandledCorrectly() throws {
        mockService.isfailur = true
        mockService.mockServiceError = ServiceError.invalidResponse
        
        let obj = GitHubRepositoriesViewModel()
        obj.serviceSession = mockService
        
        obj.fetchRepoItems(searchText: "Sample", offset: 1)
        
        XCTAssertTrue(obj.repoList.isEmpty)
        XCTAssertEqual(obj.searchOffset, 1)
        XCTAssertEqual(obj.searchHistory[0], "Sample")
    }
    
    func testFetchSearchHistoryRetrievesDataCorrectly() throws {
        let obj = GitHubRepositoriesViewModel()
        obj.fetchSearchHistory()
        
        XCTAssertGreaterThanOrEqual(obj.searchHistory.count, 0)
    }
    
    func testSaveSearchHistoryWorksCorrectly() throws {
        let obj = GitHubRepositoriesViewModel()
        obj.saveSearchHistory()
        obj.fetchSearchHistory()
        
        XCTAssertGreaterThanOrEqual(obj.searchHistory.count, 0)
    }
    
}
