import Foundation

final class WatchlistVM {
    var movies: [MovieSummary] = []
    
    var onMoviesUpdated: (() -> Void)?

    func fetchMovies() {
        movies = WatchlistStorage.shared.getAll()
        onMoviesUpdated?()
    }

    func isSaved(movieId: Int) -> Bool {
        WatchlistStorage.shared.isSaved(movieId: movieId)
    }

    func remove(movieId: Int) {
        WatchlistStorage.shared.remove(movieId: movieId)
        fetchMovies()
    }

    func posterURL<T: PosterPathProvidable>(for item: T) -> URL? {
        guard let path = item.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
