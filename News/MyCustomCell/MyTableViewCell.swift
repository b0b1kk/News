//
//  MyTableViewCell.swift
//  News
//
//  Created by Bogdan Mishura on 9/11/19.
//  Copyright © 2019 Bogdan Mishura. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    
    @IBOutlet weak var imageFromNews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for vm: ArticleViewModel) {
        self.titleLabel.text = vm.title
        self.descriptionLabel.text = vm.description
        self.authorLabel.text = vm.author
        self.sourceLabel.text = vm.source?.name
        
        if let urlImage = URL(string: vm.urlToImage ?? "") {
            let urlContents = try? Data(contentsOf: urlImage)
            if let imageData = urlContents {
                self.imageFromNews.image = UIImage(data: imageData)
            }
        }
    }

}
