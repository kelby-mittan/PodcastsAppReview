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
    
    @IBOutlet var collectionLabel: UILabel!
    
    @IBOutlet var artistNameLabel: UILabel!
    
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
        
        collectionLabel.text = podcast.collectionName
        artistNameLabel.text = podcast.artistName
        
        dateLabel.text = podcast.releaseDate.convertISODate()
        
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
        
        guard let podcast = podcast else {
            fatalError("could not load podcasts")
        }
        
        let postedPodcast = PostPodcast(trackId: podcast.trackId, favoritedBy: "Kelby", collectionName: podcast.collectionName, artworkUrl600: podcast.artworkUrl600)
        
        PodcastAPIClient.postPodcast(for: postedPodcast) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to Post", message: "\(appError)")
                    sender.isEnabled = true
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Answer Posted", message: "Thanks for submitting an answer.") { alert in
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
        
    }
    
    
}
