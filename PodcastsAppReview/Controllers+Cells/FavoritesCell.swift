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
    
    
    func configureCell(for favorite: PostPodcast) {
        collectionLabel.text = favorite.collectionName
        favoriteLabel.text = favorite.favoritedBy
        
        artworkImage.getImage(with: favorite.artworkUrl600) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.artworkImage.image = UIImage(systemName: "person.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.artworkImage.image = image
                }
            }
        }
    }
}

