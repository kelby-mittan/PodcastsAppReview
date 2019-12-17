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
    //                self.loadShows(for: self.searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    

}

