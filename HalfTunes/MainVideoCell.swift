//
//  VideoCell.swift
//  HalfTunes
//
//  Created by William Ogura on 7/15/16.
//
//
//  Updated by Charlie Rooney July 27th 2018
//

import Foundation

import UIKit

protocol MainVideoCellDelegate { func thumbnailTapped(_ cell: MainVideoCell)}

class MainVideoCell: UITableViewCell
{
    var delegate:MainVideoCellDelegate! = nil
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func thumbnailTapped(_ sender: AnyObject){delegate?.thumbnailTapped(self)}
    
    override func awakeFromNib(){super.awakeFromNib()}
    override func setSelected(_ selected: Bool, animated: Bool){super.setSelected(selected, animated: animated)}
}
