//
//  Movie.swift
//  MoviesApp
//
//  Created by Toghrul Guluzadeh on 08.01.26.
//
import Foundation

struct Movie: Decodable {

    let id: Int
    let title: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}
