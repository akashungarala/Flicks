//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Akash Ungarala on 10/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var endpoint: String!
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchData()
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        self.tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath as IndexPath) as! MovieTableViewCell
        let movie = movies![indexPath.row]
        if let posterPath = movie["poster_path"] as? String {
            let baseUrl = "https://image.tmdb.org/t/p/w342"
            let imageUrl = NSURL(string: baseUrl+posterPath)
            cell.poster.setImageWith(imageUrl! as URL)
        } else {
            cell.poster.image = nil
        }
        let title = movie["title"] as! String
        cell.name.text = title
        let overview = movie["overview"] as! String
        cell.overview.text = overview
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                fetchData()
            }
        }
    }
    
    func fetchData() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,
                                                         completionHandler: { (dataOrNil, response, error) in
                                                            if let data = dataOrNil {
                                                                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                                                    self.movies = (responseDictionary["results"] as! [NSDictionary])
                                                                    self.isMoreDataLoading = false
                                                                    self.loadingMoreView!.stopAnimating()
                                                                    MBProgressHUD.hide(for: self.view, animated: true)
                                                                    self.tableView.reloadData()
                                                                }
                                                            }
        });
        task.resume()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,
                                                         completionHandler: { (dataOrNil, response, error) in
                                                            if let data = dataOrNil {
                                                                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                                                    self.movies = (responseDictionary["results"] as! [NSDictionary])
                                                                    self.isMoreDataLoading = false
                                                                    self.loadingMoreView!.stopAnimating()
                                                                    MBProgressHUD.hide(for: self.view, animated: true)
                                                                    self.tableView.reloadData()
                                                                    refreshControl.endRefreshing()
                                                                }
                                                            }
        });
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            let movie = movies![(self.tableView.indexPathForSelectedRow?.row)!]
            destination.movie = movie
        }
    }
    
    @IBAction func closeToMovies(sender: UIStoryboardSegue) {}

}
