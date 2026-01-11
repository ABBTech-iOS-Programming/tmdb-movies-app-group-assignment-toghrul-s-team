import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ endPoint: Endpoint, completion: @escaping
        (Result<T, NetworkError>) -> Void)
}

final class DefaultNetworkService: NetworkService {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(
        _ endPoint: Endpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let createRequest = endPoint.makeRequest()

        switch createRequest {
        case .failure(let error):
            completion(.failure(error))

        case .success(let request):
            session.dataTask(with: request) { data, response, error in

                if let error {
                    return completion(.failure(.unknown(error)))
                }
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    guard (200...299).contains(statusCode) else {
                        return completion(.failure(.serverError(statusCode: statusCode)))
                    }
                }

                guard let data else {
                    return completion(.failure(.noData))
                }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError))
                }
            }.resume()
        }
    }
}
