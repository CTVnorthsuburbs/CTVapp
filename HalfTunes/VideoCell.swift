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

protocol VideoCellDelegate
{
    func pauseTapped(_ cell: VideoCell)
    func resumeTapped(_ cell: VideoCell)
    func cancelTapped(_ cell: VideoCell)
    func downloadTapped(_ cell: VideoCell)
    func thumbnailTapped(_ cell: VideoCell)
}

class VideoCell: UITableViewCell
{
    var delegate:VideoCellDelegate! = nil
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBAction func cancelTapped(_ sender: AnyObject) {delegate?.cancelTapped(self)}
    @IBAction func downloadTapped(_ sender: AnyObject) {delegate!.downloadTapped(self)}
    @IBAction func thumbnailTapped(_ sender: AnyObject) {delegate?.thumbnailTapped(self)}
    
    @IBAction func pauseOrResumeTapped(_ sender: AnyObject)
    {
        if(pauseButton.titleLabel!.text == "Pause"){delegate?.pauseTapped(self)}
        else {delegate?.resumeTapped(self)}
    }
    
    override func awakeFromNib(){super.awakeFromNib()}
    override func setSelected(_ selected: Bool, animated: Bool){super.setSelected(selected, animated: animated)}
}
