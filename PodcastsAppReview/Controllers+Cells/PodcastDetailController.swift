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
    
    @IBOutlet var favButton: UIBarButtonItem!
    
    var podcast: Podcast?
    var favorite = Bool()
    var favPodcast: PostPodcast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        
        if !favorite {
            favButton.isEnabled = true
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
        } else {
            favButton.isEnabled = false
            guard let favPodcast = favPodcast else {
                showAlert(title: "Error", message: "Could not load Favorite")
                return
            }
            
            collectionLabel.text = favPodcast.collectionName
            artistNameLabel.text = favPodcast.favoritedBy
            dateLabel.text = ""
            
            podcastArtImage.getImage(with: favPodcast.artworkUrl600) { [weak self] (result) in
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
        
    }
    
    @IBAction func favoritePodcastButton(_ sender: UIBarButtonItem) {
        
        sender.isEnabled = false
        
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
                    self?.showAlert(title: "Favorite Posted", message: "Thanks for favoriting.") { alert in
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
        
    }
    
    
}
