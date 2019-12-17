//
//  PodcastDetailController.swift
//  PodcastsAppReview
//
//  Created by Kelby Mittan on 12/17/19.
//  Copyright © 2019 Kelby Mittan. All rights reserved.
//

import UIKit

class PodcastDetailController: UIViewController {
    
    @IBOutlet var podcastArtImage: UIImageView!
    
    @IBOutlet var artistNameLabel: UILabel!
    
    @IBOutlet var collectionNameLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    var podcast: Podcast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        guard let podcast = podcast else {
            fatalError("could not get podcast")
        }
        
        artistNameLabel.text = podcast.artistName
        collectionNameLabel.text = podcast.collectionName
        
        
        podcastArtImage.getImage(with: podcast.artworkUrl600) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastArtImage.image = UIImage(systemName: "person.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.podcastArtImage.image = image
                }
            }
        }
    }
    
    @IBAction func favoritePodcastButton(_ sender: UIBarButtonItem) {
        
        
    }
    
    
}
