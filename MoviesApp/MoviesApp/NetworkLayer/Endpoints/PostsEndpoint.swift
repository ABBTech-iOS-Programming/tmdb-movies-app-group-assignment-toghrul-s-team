import Foundation

enum PostsEndpoint {
    case getPosts
    
}

extension PostsEndpoint: Endpoint {
    var baseURL: String {
        "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "/posts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPosts:
            return .get
        
        }
    }
    
    var headers: [String: String]? {
        switch self {
       
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    var HTTPBody: Encodable? {
        switch self {
      
        default:
            return nil
        }
    }
}
