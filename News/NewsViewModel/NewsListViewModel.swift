//
//  NewsListViewModel.swift
//  News
//
//  Created by Bogdan Mishura on 9/12/19.
//  Copyright © 2019 Bogdan Mishura. All rights reserved.
//

import Foundation

struct NewsListViewModel {
    
    var articlesArray = [ArticlesModel]()
    
    //MARK: - Sorted array by early date
    var articles: [ArticlesModel]{
        
        return articlesArray.sorted { (a, b) -> Bool in
            return a.publishedAt?.compare(b.publishedAt!) == ComparisonResult.orderedAscending
        }
    }
}

extension NewsListViewModel {
    
    var numberOfSection: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.articles.count
    }
    
    func articleAtIndex(_ index: Int) -> ArticleViewModel {
        
        let article = articles[index]
        return ArticleViewModel(article)
    }
    
    
    
}
