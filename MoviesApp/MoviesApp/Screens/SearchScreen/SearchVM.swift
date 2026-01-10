import Foundation

final class SearchVM {
    private let networkService: NetworkService
    var searchedFilms: [CategoricMovie] = []
    var onLoading: ((Bool) -> ())?
    var onResultsUpdated: (() -> Void)?
    var onError: ((String) -> ())?
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
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
                        print(response.results)
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
