//
//  CategoriesTableViewCell.swift
//  HalfTunes
//
//  Created by William Ogura on 11/8/16.
//
//
//  Updated by Charlie Rooney July 27th 2018
//
// Used by the CategoriesTableViewController for creating the category cells

import UIKit

class CategoriesTableViewCell: UITableViewCell
{
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    var category: Category?
    
    func setCategory(category: Category) {self.category = category}
    override func awakeFromNib(){super.awakeFromNib()}
    override func setSelected(_ selected: Bool, animated: Bool){super.setSelected(selected, animated: animated)}
}
