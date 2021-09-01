//
//  RepoItem.swift
//  GitHub Repository Search
//
//  Created by Haresh Ghatala on 2021/09/01.
//

public struct RepoItem: Codable {
    
    public let id: Int?
    public let name: String?
    public let fullName: String?
    public let isPrivate: Bool?
    public let owner: Owner?
    public let htmlUrl: String?
    public let description: String?
    public let cloneUrl: String?
    public let size: Int?
    public let language: String?
    public let score: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName
        case isPrivate = "private"
        case owner
        case htmlUrl
        case description
        case cloneUrl
        case size
        case language
        case score
    }
}

extension RepoItem: Equatable {
    
    public static func ==(lhs: RepoItem, rhs: RepoItem) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.fullName == rhs.fullName &&
            lhs.isPrivate == rhs.isPrivate &&
            lhs.owner == rhs.owner &&
            lhs.htmlUrl == rhs.htmlUrl &&
            lhs.description == rhs.description &&
            lhs.cloneUrl == rhs.cloneUrl &&
            lhs.size == rhs.size &&
            lhs.language == rhs.language &&
            lhs.score == rhs.score
    }
    
}
