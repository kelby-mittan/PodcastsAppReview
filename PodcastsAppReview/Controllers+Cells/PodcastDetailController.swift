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
    
    @IBOutlet var genreLabel: UILabel!
    
    var podcast: Podcast?
    var favorite = Bool()
    var favPodcast: PostPodcast?
    var genreArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        
        if !favorite {
            favButton.isEnabled = true
            guard let podcast = podcast, let genres = podcast.genres else {
                fatalError("could not get podcast")
            }
            for genre in genres {
                genreArr.append(genre)
            }
            genreLabel.text = "Genres: \(genreArr.joined(separator: ", "))"
            
            collectionLabel.text = podcast.collectionName
            artistNameLabel.text = podcast.artistName
            
            dateLabel.text = podcast.releaseDate.convertISODate()
            
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
            
        } else {
            favButton.isEnabled = false
            guard let favPodcast = favPodcast else {
                showAlert(title: "Error", message: "Could not load Favorite")
                return
            }
            
            PodcastAPIClient.getPodcastById(for: favPodcast.trackId) { [weak self] (result) in
                switch result {
                case .failure(let appError):
                    print(appError)
                case .success(let podcast):
                    DispatchQueue.main.async {
                        self?.collectionLabel.text = podcast.collectionName
                        self?.artistNameLabel.text = podcast.artistName
                        self?.dateLabel.text = podcast.releaseDate.convertISODate()
                        
                        guard let genres = podcast.genres else {
                            return
                        }
                        for genre in genres {
                            self?.genreArr.append(genre)
                        }
                        self?.genreLabel.text = self?.genreArr.joined(separator: ", ")
                        
                        self?.podcastArtImage.getImage(with: podcast.artworkUrl600) { [weak self] (result) in
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
            }
        }
    }
    
    
    @IBAction func favoritePodcastButton(_ sender: UIBarButtonItem) {
        
        sender.isEnabled = false
        
        guard let podcast = podcast else {
            fatalError("could not load podcasts")
        }
        
        let postedPodcast = PostPodcast(trackId: podcast.trackId, favoritedBy: "Kelby", collectionName: podcast.collectionName, artworkUrl600: podcast.artworkUrl600)
        
//        let postedPodcast = Podcast(artistName: podcast.artistName, collectionName: podcast.collectionName, artworkUrl100: podcast.artworkUrl100, artworkUrl600: podcast.artworkUrl600, trackId: podcast.trackId, releaseDate: podcast.releaseDate, favoritedBy: "Kelby", genres: podcast.genres)
        
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
