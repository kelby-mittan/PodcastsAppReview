//
//  AppError.swift
//  PodcastsAppReview
//
//  Created by Kelby Mittan on 12/16/19.
//  Copyright © 2019 Kelby Mittan. All rights reserved.
//

import Foundation

enum AppError: Error, CustomStringConvertible {
    case badURL(String) // associated value
    case noResponse
    case networkClientError(Error) // no internet connection
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case badStatusCode(Int) // 404, 500
    case badMimeType(String) // image/jpg
    
    // TODO: handle more descriptive language for error cases
    var description: String {
        return "AppError: \(self)"
    }
}
