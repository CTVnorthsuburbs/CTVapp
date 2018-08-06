//
//  CategoriesTableViewController.swift
//  HalfTunes
//
//  Created by William Ogura on 11/8/16.
//
//
//  Updated by Charlie Rooney July 27th 2018
//
//  The Category list that a user can select from. Top left button on the main screen.

import UIKit

var categoriesVideos = [Video]()
class CategoriesTableViewController: UITableViewController
{
    var parentView: MainTableViewController?
    
    //Cancel Button which will close the Categories tab.
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBAction func cancelButtonPressed(_ sender: Any)
    {
        //closes the Categories tab
        self.dismiss(animated: true, completion: {})
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        categories = search.getCategories()
        for category in categories
        {
            if(category.sections.first?.images == nil)
            {
                print("listing created for \(category.categoryTitle)")
                category.createListing()
            }
        }
    }
    
    override func didReceiveMemoryWarning(){super.didReceiveMemoryWarning()}
    
    override func numberOfSections(in tableView: UITableView) -> Int {return 1}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return categories.count}

 //Tells the delegate that the specified category is now selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(category.categoryTitle !=  categories[indexPath.row].categoryTitle )
        {
            DispatchQueue.main.async(){LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)}
            category = categories[indexPath.row]
            
            //sets parent view to the new category
            let parentView =  self.presentingViewController?.childViewControllers.first?.childViewControllers.first as! MainTableViewController
            parentView.setCategory(newCategory: categories[indexPath.row])
        }
        
        //closes the Categories tab
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CategoriesTableViewCell
    {
        //creates the cell for the category
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath) as? CategoriesTableViewCell
        
        cell?.setCategory(category: categories[indexPath.row])
        
        //Sets the category title for each category cell
        let categoryTitle = categories[indexPath.row].categoryTitle
        cell?.categoryTitle.text = categoryTitle
        
        //Getting image for category
        var thumbnail: UIImage?
        cell?.thumbnailImage.setRadius(radius: imageRadius)
            if (categoriesVideos[indexPath.row].fileName == 0)//concerts,news,sports,etc (the ones on the main page)....
            {
                thumbnail = categoriesVideos[indexPath.row].thumbnail
            }
            else if(categoriesVideos[indexPath.row].fileName != nil)//other categories (not on main/home page).....
            {
                thumbnail = categories[indexPath.row].getSlider()?.getCategoryImage()
            }
            else{}
        
     //Current Category Attributes
        if (categoryTitle == category.categoryTitle)
        {
            //highlights Category in light blue if it is the current category and is checked marked.
            cell?.categoryTitle.isHighlighted = true
            cell?.accessoryType = .checkmark
        }
        else
        {
            ////If not current category plain black text and not checked marked
            cell?.categoryTitle.isHighlighted = false
            cell?.accessoryType = .none
        }
        
     //Sets the thumnail image for each of the categories
        if(thumbnail != nil )
        {
            //If there is a thumnail image it uses it.
            cell?.thumbnailImage.image = thumbnail
        }
        else
        {
            //If there is not a thumbnail image for a specific category it is just a black image.
            cell?.thumbnailImage.image = #imageLiteral(resourceName: "defaultPhoto")
        }
        return cell!
    }//override func tableView
    
}//class CategoriesTableViewController
