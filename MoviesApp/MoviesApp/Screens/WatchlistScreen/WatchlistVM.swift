import Foundation

final class WatchlistVM {

    func fetchMovies() -> [MovieSummary] {
        WatchlistStorage.shared.getAll()
    }

    func isSaved(movieId: Int) -> Bool {
        WatchlistStorage.shared.isSaved(movieId: movieId)
    }

    func remove(movieId: Int) {
        WatchlistStorage.shared.remove(movieId: movieId)
    }
}
