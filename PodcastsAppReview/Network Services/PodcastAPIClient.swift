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
    
    static func postPodcast(for postedPodcast: PostPodcast, completion: @escaping (Result<Bool, AppError>) -> ()) {
        
        let favoritePodcastEndpoint = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
        
        guard let url = URL(string: favoritePodcastEndpoint) else {
            return
        }
        
        do {
            let data = try JSONEncoder().encode(postedPodcast)
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "Post"
            
            // 3. let web API know the type of data being sent
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // 4. use httpBody on request to add the data from the postAnswer model
            /*
                 {
                     "description": "When I run my app there isn't any data being loaded into my table view",
                     "title": "Can't get data in my table view - Kelby",
                     "labName": "Comic Lab"
                 }
             */
            request.httpBody = data
            
            // now we will use NetworkHelper (URLSession wrapper class) to make the network POST request
            
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
            
        } catch {
            completion(.failure(.encodingError(error)))
        }
        
    }
}
