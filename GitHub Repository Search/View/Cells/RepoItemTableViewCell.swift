//
//  RepoItemTableViewCell.swift
//  GitHub Repository Search
//
//  Created by Haresh Ghatala on 2021/09/01.
//

import UIKit

class RepoItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = 40
            avatarImageView.layer.borderWidth = 5
            avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    
    public var cellData: RepoItem! {
        didSet {
            if let imgUrl = cellData.owner?.avatarUrl {
                avatarImageView.load(urlStr: imgUrl, placeholder: true)
            }
            
            repoNameLabel.text = cellData.name ?? emptyValue
            ownerNameLabel.text = cellData.owner?.login ?? emptyValue
            languagesLabel.text = cellData.language ?? emptyValue
            repoDescriptionLabel.text = cellData.description ?? emptyValue
        }
    }
    
    override func prepareForReuse() {
        avatarImageView.image = UIImage()
    }
}
