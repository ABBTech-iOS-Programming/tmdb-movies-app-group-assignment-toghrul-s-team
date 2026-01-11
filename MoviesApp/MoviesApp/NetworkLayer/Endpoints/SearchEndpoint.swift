import Foundation

import Foundation

enum SearchEndpoint: Endpoint {
    case search(query: String)

    var baseURL: String {
        NetworkConstants.baseURL
    }

    var path: String {
        switch self {
        case .search:
            return "/3/search/movie"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String: String]? {
        [
            "Authorization": "Bearer \(NetworkConstants.accessToken)",
            "accept": "application/json"
        ]
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let query):
            return [URLQueryItem(name: "query", value: query)]
        }
    }

    var HTTPBody: Encodable? {
        nil
    }
}
