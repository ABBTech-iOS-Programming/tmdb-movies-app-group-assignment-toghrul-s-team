import Foundation

final class DetailVM {
    private let movieId: Int
    private let networkService: NetworkService
    private let watchlist = WatchlistStorage.shared

    private(set) var reviews: [Review] = []

    var onDetailLoaded: ((MovieDetailResponse) -> Void)?
    var onReviewsLoaded: (([Review]) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onWatchlistStateChanged: ((Bool) -> Void)?

    init(
        movieId: Int,
        networkService: NetworkService = DefaultNetworkService()
    ) {
        self.movieId = movieId
        self.networkService = networkService
    }

    func loadDetail() {
        DispatchQueue.main.async {
            self.onLoading?(true)
        }

        networkService.request(
            MovieDetailEndpoint.detail(id: movieId)
        ) { [weak self] (result: Result<MovieDetailResponse, NetworkError>) in
            guard let self else { return }

            DispatchQueue.main.async {
                self.onLoading?(false)

                switch result {
                case .success(let detail):
                    self.onDetailLoaded?(detail)
                    let isSaved = self.watchlist.isSaved(movieId: detail.id)
                    self.onWatchlistStateChanged?(isSaved)

                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }

    func loadReviews() {
        DispatchQueue.main.async {
            self.onLoading?(true)
        }

        networkService.request(
            MovieDetailEndpoint.reviews(id: movieId)
        ) { [weak self] (result: Result<ReviewResponse, NetworkError>) in
            guard let self else { return }

            DispatchQueue.main.async {
                self.onLoading?(false)

                switch result {
                case .success(let response):
                    self.reviews = response.results
                    self.onReviewsLoaded?(response.results)

                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }

    func toggleWatchlist(detail: MovieDetailResponse) {
        let movie = MovieSummary(
            id: detail.id,
            title: detail.title,
            posterPath: detail.posterPath,
            voteAverage: detail.voteAverage
        )

        if watchlist.isSaved(movieId: detail.id) {
            watchlist.remove(movieId: detail.id)
            onWatchlistStateChanged?(false)
        } else {
            watchlist.add(movie: movie)
            onWatchlistStateChanged?(true)
        }
    }

    func isInWatchlist(movieId: Int) -> Bool {
        watchlist.isSaved(movieId: movieId)
    }
}
