//
//  HorizontalTableViewCell.swift
//  HalfTunes
//
//  Created by William Ogura on 10/21/16.
//
//
//  Updated by Charlie Rooney July 27th 2018
//

import UIKit


class HorizontalTableViewCell: UITableViewCell
{
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var sectionLabel: UILabel!
    func disableSeeAllButton() {seeAllButton.isHidden = true}
}//class HorizontalTableViewCell: UITableViewCell

extension HorizontalTableViewCell
{
    func setCollectionViewDataSourceDelegate(_ delegate: UICollectionViewDelegate, _ dataSource: UICollectionViewDataSource, forRow row: Int)
    {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        if collectionView.tag != row
        {
            collectionView.tag = row
            collectionView.reloadData()
        }
    }
    
    func reloadCell()
    {
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    var collectionViewOffset: CGFloat
    {
        set{collectionView.contentOffset.x = newValue}
        get {return collectionView.contentOffset.x}
    }
}//extension HorizontalTableViewCell
