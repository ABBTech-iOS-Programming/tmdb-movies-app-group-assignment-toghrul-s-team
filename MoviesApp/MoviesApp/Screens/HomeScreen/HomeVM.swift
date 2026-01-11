import Foundation

protocol PosterPathProvidable {
    var posterPath: String? { get }
}

final class HomeVM {
    var categoriesArray: [String] = []
    func fetchCategories() -> [String] {
        for item in CategoricMoviesEndPoint.allCases {
            categoriesArray.append(item.rawValue)
        }
        return categoriesArray
    }

    private let networkService: NetworkService

    var featuredMovies: [Movie] = []
    var nowPlayingMovies: [CategoricMovie] = []
    var searchedFilms: [CategoricMovie] = []

    var onFeaturedUpdated: (() -> Void)?
    var onNowPlayingUpdated: (() -> Void)?
    var onResultsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }

    func loadFeatured() {
        onLoading?(true)

        networkService.request(TrendingMoviesEndpoint.day) { [weak self]
            (result: Result<MovieResponse, NetworkError>) in
                DispatchQueue.main.async {
                    guard let self else { return }

                    self.onLoading?(false)

                    switch result {
                    case .success(let response):
                        self.featuredMovies = response.results
                        self.onFeaturedUpdated?()

                    case .failure(let error):
                        self.onError?(error.localizedDescription)
                    }
                }
        }
    }

    func loadCategoricMovies(of type: CategoricMoviesEndPoint) {
        onLoading?(true)
        networkService.request(type) { [weak self]
            (result: Result<CategoricResponse, NetworkError>) in
                DispatchQueue.main.async {
                    guard let self else { return }

                    self.onLoading?(false)

                    switch result {
                    case .success(let response):
                        self.nowPlayingMovies = response.results
                        self.onNowPlayingUpdated?()

                    case .failure(let error):
                        self.onError?(error.localizedDescription)
                    }
                }
        }
    }

    func loadCategoricMovies(text: String) {
        onLoading?(true)
        networkService.request(SearchEndpoint.search(query: text)) { [weak self]
            (result: Result<CategoricResponse, NetworkError>) in
                DispatchQueue.main.async {
                    guard let self else { return }

                    self.onLoading?(false)

                    switch result {
                    case .success(let response):
                        self.searchedFilms = response.results
                        self.onResultsUpdated?()

                    case .failure(let error):
                        self.onError?(error.localizedDescription)
                    }
                }
        }
    }

    func posterURL<T: PosterPathProvidable>(for item: T) -> URL? {
        guard let path = item.posterPath else { return nil }

        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
