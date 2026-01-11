struct ReviewResponse: Decodable {
    let results: [Review]
}

struct Review: Decodable {
    let author: String
    let content: String
    let authorDetails: AuthorDetails?
}

struct AuthorDetails: Decodable {
    let rating: Double?
    let avatarPath: String?
}
