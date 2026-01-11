import Foundation

enum TrendingMoviesEndpoint: Endpoint {
    case day
    case week

    var baseURL: String {
        NetworkConstants.baseURL
    }

    var path: String {
        switch self {
        case .day:
            return "/3/trending/movie/day"
        case .week:
            return "/3/trending/movie/week"
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
        nil
    }

    var HTTPBody: Encodable? {
        nil
    }
}
