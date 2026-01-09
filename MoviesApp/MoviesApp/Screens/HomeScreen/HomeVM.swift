import Foundation

final class HomeVM {

    private let networkService: NetworkService

    struct MovieResponse: Decodable {
        let results: [Movie]
    }

    var featuredMovies: [Movie] = []
    var onFeaturedUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }

    func loadFeatured() {
        networkService.request(TrendingMoviesEndpoint.day) {
            [weak self] (result: Result<MovieResponse, NetworkError>) in

            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.featuredMovies = response.results
                    self?.onFeaturedUpdated?()

                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }

    func posterURL(for movie: Movie) -> URL? {
        guard let path = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
