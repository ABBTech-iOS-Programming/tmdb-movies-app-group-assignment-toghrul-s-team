import Foundation
enum CategoricMoviesEndPoint: String, CaseIterable,Endpoint {
    
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case popular = "Popular"

    var baseURL: String {
        NetworkConstants.baseURL
    }

    var path: String {
        switch self {
        case .nowPlaying:
            return "/3/movie/now_playing"
        case .upcoming:
            return "/3/movie/upcoming"
        case .topRated:
            return "/3/movie/top_rated"
        case .popular:
            return "/3/movie/popular"
            
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
