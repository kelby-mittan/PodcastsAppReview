//
//  PodcastSearch.swift
//  PodcastsAppReview
//
//  Created by Kelby Mittan on 12/16/19.
//  Copyright © 2019 Kelby Mittan. All rights reserved.
//

import Foundation

struct PodcastSearch: Codable {
    let results: [Podcast]
}

struct Podcast: Codable {
    
    let artistName: String?
    let collectionName: String
    let artworkUrl100: String?
    let artworkUrl600: String
    let trackId: Int
    let releaseDate: String?
    let favoritedBy: String?
    let genres: [String]?
    
}
