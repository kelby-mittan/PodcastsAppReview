//
//  PodcastAPIClient.swift
//  PodcastsAppReview
//
//  Created by Kelby Mittan on 12/16/19.
//  Copyright © 2019 Kelby Mittan. All rights reserved.
//

import Foundation

struct PodcastAPIClient {
    static func fetchPodcasts(for searchQuery: String, completion: @escaping (Result<[Podcast],AppError>) -> ()) {
        
        let podcastEndpointString = "https://itunes.apple.com/search?media=podcast&limit=200&term=\(searchQuery)"
        
        guard let url = URL(string: podcastEndpointString) else {
            completion(.failure(.badURL(podcastEndpointString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let podcastSearch = try JSONDecoder().decode(PodcastSearch.self, from: data)
                    let podcasts = podcastSearch.results
                    completion(.success(podcasts))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
