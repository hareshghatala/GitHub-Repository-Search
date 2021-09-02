//
//  MockService.swift
//  GitHub Repository SearchTests
//
//  Created by Haresh Ghatala on 2021/09/02.
//

import XCTest
@testable import GitHub_Repository_Search

class MockService: Service {
    
    public static let mockShared = MockService()
    override init() {
        super.init()
    }
    
    var isfailur: Bool = false
    var mockServiceError: ServiceError?
    var mockResponse: RepoSearchData?
    
    override func fetchResources<T>(url: URL, queryParams: [String : String]? = nil, completion: @escaping (Result<T, ServiceError>) -> Void) where T : Decodable {
        if isfailur {
            completion(.failure(mockServiceError!))
        } else {
            completion(.success(mockResponse as! T))
        }
    }
    
}
