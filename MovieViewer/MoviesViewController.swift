//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Richard Rolle on 1/6/16.
//  Copyright © 2016 richard rolle. All rights reserved.
//
import UIKit
import AFNetworking
import MBProgressHUD
import PSTAlertController_HYPNetworkError
let refreshControl = UIRefreshControl()
let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
let request = NSURLRequest(URL: url!)
let session = NSURLSession(
    configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
    delegate:nil,
    delegateQueue:NSOperationQueue.mainQueue()
)

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func loadDataFromNetwork() {

        // Display HUD right before next request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // ...
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                // ...
                
        });
        task.resume()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl

        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged);tableView.insertSubview(refreshControl, atIndex: 0)
        
        
    
        
        tableView.dataSource = self
        tableView.delegate = self
        
        MBProgressHUD.showHUDAddedTo(self.view, animated:  true)
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                            
                            
                    }
                }
        });
        task.resume()

        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWithURL(imageUrl!)
        
        
        
        print("row \(indexPath.row)")
        return cell
    }

    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // Make network request to fetch latest data
        
        // Do the following when the network request comes back successfully:
        // Update tableView data source
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
