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
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - configuration for cell
    func configure(for vm: ArticleViewModel, indexPath: IndexPath) {
        self.titleLabel.text = vm.title
        self.descriptionLabel.text = vm.description
        self.authorLabel.text = vm.author
        self.sourceLabel.text = vm.source?.name
        
        //MARK: - fetch image for news with safe and check image in cache
        
        if let cachedImage = imageCache.object(forKey: vm.urlToImage! as NSString) {
            self.imageFromNews.image = cachedImage
            
        } else {
            if let url = URL(string: vm.urlToImage ?? "") {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data, let image = UIImage(data: data) else {return}
                    self.imageCache.setObject(image, forKey: vm.urlToImage! as NSString)
                    DispatchQueue.main.async {
                        if self.tag == indexPath.row {
                            self.imageFromNews.image = image
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
