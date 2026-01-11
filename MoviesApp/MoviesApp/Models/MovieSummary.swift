struct MovieSummary: Codable, Equatable, PosterPathProvidable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
}
