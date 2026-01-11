//
//  MovieSummary.swift
//  MoviesApp
//
//  Created by Toghrul Guluzadeh on 11.01.26.
//
struct MovieSummary: Codable, Equatable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
}
