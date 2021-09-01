//
//  Owner.swift
//  GitHub Repository Search
//
//  Created by Haresh Ghatala on 2021/09/01.
//

public struct Owner: Codable {
    
    public let login: String?
    public let id: Int?
    public let avatarUrl: String?
    
}

extension Owner: Equatable {
    
    public static func ==(lhs: Owner, rhs: Owner) -> Bool {
        return lhs.login == rhs.login &&
            lhs.id == rhs.id &&
            lhs.avatarUrl == rhs.avatarUrl
    }
    
}
