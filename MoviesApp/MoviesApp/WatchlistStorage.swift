import Foundation

final class WatchlistStorage {
    static let shared = WatchlistStorage()
    private let key = "watchlist_movies"

    private init() {}

    func getAll() -> [MovieSummary] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let list = try? JSONDecoder().decode([MovieSummary].self, from: data)
        else { return [] }

        return list
    }

    func isSaved(movieId: Int) -> Bool {
        getAll().contains { $0.id == movieId }
    }

    func add(movie: MovieSummary) {
        var list = getAll()

        let alreadyExists = list.contains { item in
            item.id == movie.id
        }
        guard !alreadyExists else { return }

        list.append(movie)
        save(list)
    }

    func remove(movieId: Int) {
        var list = getAll()
        list.removeAll { $0.id == movieId }
        save(list)
    }

    private func save(_ list: [MovieSummary]) {
        let data = try? JSONEncoder().encode(list)
        UserDefaults.standard.set(data, forKey: key)
    }
}
