import Foundation

struct CategoricResponse: Decodable {
    let dates: Dates?
    let page: Int
    let results: [CategoricMovie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Decodable {
    let maximum: String
    let minimum: String
}

struct CategoricMovie: Decodable, PosterPathProvidable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIds: [Int]
    let adult: Bool
    let video: Bool
    let originalLanguage: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case popularity
        case adult
        case video

        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
    }
}
