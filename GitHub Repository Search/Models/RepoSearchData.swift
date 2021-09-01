//
//  RepoSearchData.swift
//  GitHub Repository Search
//
//  Created by Haresh Ghatala on 2021/09/01.
//

public struct RepoSearchData: Codable {
    
    public let totalCount: Int?
    public let incompleteResults: Bool?
    public let items: [RepoItem]?
    
}

extension RepoSearchData: Equatable {
    
    public static func ==(lhs: RepoSearchData, rhs: RepoSearchData) -> Bool {
        return lhs.totalCount == rhs.totalCount &&
            lhs.incompleteResults == rhs.incompleteResults &&
            lhs.items == rhs.items
    }
    
}
