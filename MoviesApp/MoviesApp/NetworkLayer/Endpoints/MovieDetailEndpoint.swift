//
//  MovieDetailEndpoint.swift
//  MoviesApp
//
//  Created by Toghrul Guluzadeh on 11.01.26.
//
import Foundation

enum MovieDetailEndpoint {
    case detail(id: Int)
    case reviews(id: Int)
}

extension MovieDetailEndpoint: Endpoint {

    var baseURL: String {
        NetworkConstants.baseURL
    }

    var path: String {
        switch self {
        case .detail(let id):
            return "/3/movie/\(id)"
        case .reviews(let id):
            return "/3/movie/\(id)/reviews"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String : String]? {
        [
            "Authorization": "Bearer \(NetworkConstants.accessToken)",
            "Content-Type": "application/json"
        ]
    }

    var queryItems: [URLQueryItem]? {
        nil
    }

    var HTTPBody: Encodable? {
        nil
    }
}
