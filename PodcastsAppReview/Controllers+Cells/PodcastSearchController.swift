//
//  ViewController.swift
//  PodcastsAppReview
//
//  Created by Kelby Mittan on 12/16/19.
//  Copyright © 2019 Kelby Mittan. All rights reserved.
//

import UIKit

class PodcastSearchController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    var podcasts = [Podcast]() {
            didSet {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        var searchQuery = "" {
            didSet {
                DispatchQueue.main.async {
                    self.loadPodcasts(for: self.searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    
    private func loadPodcasts(for search: String) {
        PodcastAPIClient.fetchPodcasts(for: search) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print(appError)
            case .success(let podcasts):
                DispatchQueue.main.async {
                    self?.podcasts = podcasts
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let podcastVC = segue.destination as? PodcastDetailController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("could not load")
        }
        podcastVC.podcast = podcasts[indexPath.row]
    }

    

}

extension PodcastSearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodcastCell else {
            fatalError()
        }
        
        let podcast = podcasts[indexPath.row]
        
        cell.configureCell(for: podcast)
        
        return cell
    }
}

extension PodcastSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

extension PodcastSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else {
            return
        }
        searchQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        PodcastAPIClient.fetchPodcasts(for: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print(appError)
            case .success(let podcasts):
                DispatchQueue.main.async {
                    self?.podcasts = podcasts
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        searchQuery = searchQuery.replacingOccurrences(of: " ", with: "")

        PodcastAPIClient.fetchPodcasts(for: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print(appError)
            case .success(let podcasts):
                DispatchQueue.main.async {
                    self?.podcasts = podcasts
                }
            }
        }
    }
    
}



