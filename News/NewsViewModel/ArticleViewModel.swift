//
//  ArticleViewModel.swift
//  News
//
//  Created by Bogdan Mishura on 9/12/19.
//  Copyright © 2019 Bogdan Mishura. All rights reserved.
//

import Foundation

struct ArticleViewModel {
    
    private let article: ArticlesModel
}

extension ArticleViewModel {
    init(_ article: ArticlesModel) {
        self.article = article
    }
}

extension ArticleViewModel {
    
    var source: SourceModel? {
        return self.article.source
    }
    
    var author: String? {
        return self.article.author
    }
    
    var title: String? {
        return self.article.title
    }
    
    var description: String? {
        return self.article.description
    }
    
    var url: String? {
        return self.article.url
    }
    
    var urlToImage: String? {
        return self.article.urlToImage
    }
    
    var publishedAt: String? {
        return self.article.publishedAt
    }
    
    var content: String? {
        return self.article.content
    }
}
