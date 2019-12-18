//
//  PodcastCell.swift
//  PodcastsAppReview
//
//  Created by Kelby Mittan on 12/16/19.
//  Copyright © 2019 Kelby Mittan. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    @IBOutlet var podcastArtImage: UIImageView!
    
    @IBOutlet var collectionLabel: UILabel!
    
    @IBOutlet var artistLabel: UILabel!
    
    func configureCell(for podcast: Podcast) {
        collectionLabel.text = podcast.collectionName
        artistLabel.text = podcast.artistName
        
        podcastArtImage.getImage(with: podcast.artworkUrl600) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastArtImage.image = UIImage(systemName: "music.house.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.podcastArtImage.image = image
                }
            }
        }
    }
    
}
