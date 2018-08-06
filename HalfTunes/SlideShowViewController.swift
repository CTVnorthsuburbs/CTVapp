//  SlideShow.swift
//  HalfTunes
//
//  Created by William Ogura on 10/25/16.
// Updated by Charlie Rooney
//
// Top images Not really a slider, that is just what William named it.
// Displays the category images at the top of those types of screens. Like the home screen image or like the baseball or Concert image.
//
// Note does not work when you select any of the Browse by options on the Home Screen for some reason. May want to look into that.
// Updated by Charlie Rooney July 27th 2018
//
//
// NOT REALLY A SLIDESHOW: IGNORE THE CLASS NAME!!!!!!!!!!!!!!!!!!!!!
//

import UIKit
import AVFoundation
import Foundation
class SlideShowViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleTextLabel: UILabel!

    var imageArray = [UIImage]()
    var slides: [Slide]?
    
    override func viewDidLoad() {imageArray = [#imageLiteral(resourceName: "placeholder-header")]}
    override func showLoadingOverlay(){DispatchQueue.main.async( execute: {LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)})}
    func dismissLoadingOverlay(){ DispatchQueue.main.async( execute: {LoadingOverlay.shared.hideOverlayView()})}
    
    //sets the initial opening of app top image
    override func viewDidLayoutSubviews()
    {
        mainScrollView.frame = view.frame
        let imageView = UIImageView()
        imageView.image = imageArray[0]
        imageView.contentMode  = .scaleAspectFit
        let xPostion = self.view.frame.width * CGFloat(0)
        imageView.frame = CGRect(x: xPostion, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height )
        mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(0 + 1)
        mainScrollView.addSubview(imageView)
        let parent = self.parent as! MainTableViewController
        parent.vc = self
    }//func  viewDidLayoutSubviews

    //Sets the image at the top of the screen for every change in category after the first initial opening of the app
    func setSlider(slider: Section)
    {
        imageArray = [UIImage]()
        self.slides = slider.slides
        let images = slider.images as! [UIImage]
        if(images.count > 0) {self.imageArray = images}
        for i in  0..<imageArray.count
        {
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode  = .scaleAspectFit
            let xPostion = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPostion, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height )
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.addSubview(imageView)
        }
    }//func setSlider
}//SlideShowViewController
