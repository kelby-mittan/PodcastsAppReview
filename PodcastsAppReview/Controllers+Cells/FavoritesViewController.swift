//
//  FavoritesViewController.swift
//  PodcastsAppReview
//
//  Created by Kelby Mittan on 12/17/19.
//  Copyright © 2019 Kelby Mittan. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
        
    var podcasts = [Podcast]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        loadPodcasts()
        configureRefreshControl()
    }
    
    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(loadPodcasts), for: .valueChanged)
    }
    
    @objc

    private func loadPodcasts() {
        
        PodcastAPIClient.getFavorites { [weak self] (results) in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            switch results {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")

                }
            case .success(let podcasts):
                DispatchQueue.main.async {
                    self?.podcasts = podcasts
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let podcastVC = segue.destination as? PodcastDetailController, let indexPath = tableView.indexPathForSelectedRow else {
            print("could not load")
            return
        }
        podcastVC.favPodcast = podcasts[indexPath.row]
        podcastVC.favorite = true
    }
    
    
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as? FavoritesCell else {
            fatalError()
        }
        
        let podcast = podcasts[indexPath.row]
        
        cell.configureCell(for: podcast)
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

