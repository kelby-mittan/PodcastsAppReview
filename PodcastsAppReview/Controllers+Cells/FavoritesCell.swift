//
//  FavoritesCell.swift
//  PodcastsAppReview
//
//  Created by Kelby Mittan on 12/17/19.
//  Copyright © 2019 Kelby Mittan. All rights reserved.
//

import UIKit

class FavoritesCell: UITableViewCell {
    
    @IBOutlet var artworkImage: UIImageView!
    @IBOutlet var collectionLabel: UILabel!
    @IBOutlet var favoriteLabel: UILabel!
    
    private var urlString = ""
    
    func configureCell(for favorite: Podcast) {
        collectionLabel.text = favorite.collectionName
        
        favoriteLabel.text = "Favorited by: \(favorite.favoritedBy ?? "Unknown")"
        
        let imageURL = favorite.artworkUrl600
        
        urlString = imageURL
        
        artworkImage.getImage(with: imageURL) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.artworkImage.image = UIImage(systemName: "mic.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    if self?.urlString == imageURL {
                        self?.artworkImage.image = image
                    }
                    
                }
            }
        }
    }
}

