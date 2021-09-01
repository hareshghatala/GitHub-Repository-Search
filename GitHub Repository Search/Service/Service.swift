//
//  Service.swift
//  GitHub Repository Search
//
//  Created by Haresh Ghatala on 2021/09/01.
//

import Foundation

public enum ServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

class Service {
    
    public static let shared = Service()
    init() {}
    
    private let urlSession = URLSession.shared
    
    private let baseURL = URL(string: githubBaseURLString)!
    private let limit = apiDataLimit
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
    
    /// Enum endpoints
    enum Endpoint: String {
        case repositories
    }
    
    /// Query parameters
    enum QueryParams: String {
        case searchText = "q"
        case perPageLimit = "per_page"
        case pageOffset = "page"
    }
    
    /// Common get service call
    func fetchResources<T: Decodable>(url: URL, queryParams: [String: String]? = nil, completion: @escaping (Result<T, ServiceError>) -> Void) {
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        if let queryParams = queryParams?.map({ URLQueryItem(name: $0.key, value: $0.value) }) {
            urlComponents.queryItems = queryParams
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        print("Request Url: \(url.absoluteString)")
        urlSession.dataTask(with: url) { result in
            switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    
                    do {
                        let values = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(values))
                    } catch {
                        print(error)
                        completion(.failure(.decodeError))
                    }
                
                case .failure( _):
                    completion(.failure(.apiError))
            }
        }.resume()
    }
    
    // MARK: - Service call prebuild methods
    
    public func SearchRepositories(searchText: String, offset: Int = 0, result: @escaping (Result<RepoSearchData, ServiceError>) -> Void) {
        let infoURL = baseURL.appendingPathComponent(Endpoint.repositories.rawValue)
        let searchStr = "is:public \(searchText) in:name,description,readme"
        let params: [String: String] = [ QueryParams.searchText.rawValue: searchStr,
                                         QueryParams.perPageLimit.rawValue: "\(limit)",
                                         QueryParams.pageOffset.rawValue: "\(offset)"]
        
        fetchResources(url: infoURL, queryParams: params, completion: result)
    }
    
}
