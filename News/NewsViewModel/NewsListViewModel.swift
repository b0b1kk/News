//
//  NewsListViewModel.swift
//  News
//
//  Created by Bogdan Mishura on 9/12/19.
//  Copyright © 2019 Bogdan Mishura. All rights reserved.
//

import Foundation

struct NewsListViewModel {
    
    var articles: [ArticlesModel]

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
