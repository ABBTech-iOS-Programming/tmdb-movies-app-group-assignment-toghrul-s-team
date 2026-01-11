import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable, PosterPathProvidable {
    let id: Int
    let title: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}
