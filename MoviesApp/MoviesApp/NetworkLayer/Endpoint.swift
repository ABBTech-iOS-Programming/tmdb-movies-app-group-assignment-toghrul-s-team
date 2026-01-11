import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var HTTPBody: Encodable? { get }
}

extension Endpoint {
    func makeRequest() -> Result<URLRequest, NetworkError> {
        guard var compotents = URLComponents(string: baseURL) else {
            return .failure(.invalidURL)
        }

        compotents.path = path
        compotents.queryItems = queryItems

        guard let url = compotents.url else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        headers?.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        if let HTTPBody {
            do {
                let encodedData = try JSONEncoder().encode(HTTPBody)
                request.httpBody = encodedData
            } catch {
                return .failure(.encodingError)
            }
        }
        return .success(request)
    }
}
