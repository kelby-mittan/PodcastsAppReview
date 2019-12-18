//
//  PodcastsAppReviewTests.swift
//  PodcastsAppReviewTests
//
//  Created by Kelby Mittan on 12/16/19.
//  Copyright © 2019 Kelby Mittan. All rights reserved.
//

import XCTest
@testable import PodcastsAppReview

class PodcastsAppReviewTests: XCTestCase {

    
    func testPodcastCount() {
        
        let searchQuery = "swift".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let exp = XCTestExpectation(description: "searches found")
        let episodesEndpointURL = "https://itunes.apple.com/search?media=podcast&limit=200&term=\(searchQuery)"
        
        let request = URLRequest(url: URL(string: episodesEndpointURL)!)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("\(appError)")
            case .success(let data):
                do {
                    let searchResults = try JSONDecoder().decode(PodcastSearch.self, from: data)
                    let podcasts = searchResults.results
                    
                    XCTAssertEqual(podcasts.count, 123, "Should be 123")
                } catch {
                    XCTFail()
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 5.0)
    }

}
