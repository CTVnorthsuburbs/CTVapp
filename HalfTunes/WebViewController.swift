//
//  WebViewController.swift
//  HalfTunes
//
//  Created by William Ogura on 12/14/16.
//
//
//  Updated by Charlie Rooney July 27th 2018
//

import UIKit

class WebViewController: UIViewController
{
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var webView: UIWebView!
    @IBAction func refreshAction(sender: AnyObject) { webView.reload()}
    
    var url: URL?
    
    func setTitle(title: String) { navigationTitle.title = title}
    func setPage(url: URL) { self.url = url }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if(url != nil) { webView.loadRequest(NSURLRequest(url: url!) as URLRequest) }
    }
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
}
