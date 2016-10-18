//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Akash Ungarala on 10/14/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import UIKit
import Foundation

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var overview: UITextView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let posterPath = movie["poster_path"] as? String {
            let baseUrl = "https://image.tmdb.org/t/p/w342"
            let imageUrl = NSURL(string: baseUrl+posterPath)
            poster.setImageWith(imageUrl! as URL)
        } else {
            poster.image = nil
        }
        name.text = movie["original_title"] as? String
        releaseDate.text = convertDateFormater(date: (movie["release_date"] as? String)!)
        let popularityPercentage = movie["popularity"] as! Double
        popularity.text = String(format: "%.0f%", popularityPercentage)+"%"
        overview.text = movie["overview"] as? String
    }
    
    func convertDateFormater(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    
}
