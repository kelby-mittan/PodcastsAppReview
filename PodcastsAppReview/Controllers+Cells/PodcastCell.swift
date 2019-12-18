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
    
    private var urlString = ""
    
    func configureCell(for podcast: Podcast) {
        collectionLabel.text = podcast.collectionName
        artistLabel.text = podcast.artistName
        
        let imageURL = podcast.artworkUrl600
        
        urlString = imageURL
        
        podcastArtImage.getImage(with: imageURL) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastArtImage.image = UIImage(systemName: "mic.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    if self?.urlString == imageURL {
                        self?.podcastArtImage.image = image
                    }
                    
                }
            }
        }
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      podcastArtImage.image = UIImage(systemName: "mic.fill")
    }
    
}
