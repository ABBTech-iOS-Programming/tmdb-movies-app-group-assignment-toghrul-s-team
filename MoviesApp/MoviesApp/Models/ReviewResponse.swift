//
//  ReviewResponse.swift
//  MoviesApp
//
//  Created by Toghrul Guluzadeh on 11.01.26.
//
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
