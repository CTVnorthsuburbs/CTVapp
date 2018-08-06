//
//  AllVideosResultControllerView.swift
//  HalfTunes
//
//  Created by William Ogura on 8/19/16.
//
//
//  Updated by Charlie Rooney July 27th 2018
//

import Foundation
import UIKit

class AllVideosResultsViewController: UITableViewController,  UISearchBarDelegate, UISearchDisplayDelegate
{
    //   var searchResults = [Video]()
    var searchBar: UISearchBar!
    var searchActive : Bool = false
    var data = [String]()
    var filtered:[String] = []
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var allVideosResults: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        self.tableView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        if segue.identifier == "ShowDetails"
        {
            let videoDetailViewController = segue.destination as! VideoViewController
            // Get the cell that generated this segue.
            if let selectedVideoCell = sender
            {
                let indexPath = self.tableView.indexPath(for: selectedVideoCell as! UITableViewCell)!
                var count = 0  //code to map filtered result position to searchResult position
                
                for result in searchResults
                {
                    if (self.filtered[(indexPath as NSIndexPath).row] == result.title)
                    {
                        let selectedVideo = searchResults[count]
                        videoDetailViewController.video = selectedVideo
                        var defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
                        var dataTask = URLSessionDataTask()
                        var downloadsSession: Foundation.URLSession =
                        {
                            let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
                            let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
                            return session
                        }()
                            
                        if(selectedVideo.fileName == 1)
                        {
                            let sections = Category(categoryFactory: CategoryFactory(factorySettings: teens()))
                            sections.createListing()
                            videoDetailViewController.setCategory(category: sections)
                        }
                        else
                        {
                            let sections = Category(categoryFactory: CategoryFactory(factorySettings: home()))
                            sections.createListing()
                            suggestedSearch = sections.sections[1]
                        }
                        
                        videoDetailViewController.setDefaultSession(defaultSession: &defaultSession)
                        videoDetailViewController.setDataTask(dataTask: &dataTask)
                        videoDetailViewController.setDownloadsSession(downloadsSession: &downloadsSession)
                    }
                    count += 1
                }
            }
            DispatchQueue.main.async( execute: {LoadingOverlay.shared.hideOverlayView()})
        }
    }
}

extension AllVideosResultsViewController: URLSessionDelegate
{
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession)
    {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler
            {
                appDelegate.backgroundSessionCompletionHandler = nil
                DispatchQueue.main.async(execute: {completionHandler()})
            }
        }
    }
}
