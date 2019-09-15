//
//  NetworkManager.swift
//  News
//
//  Created by Bogdan Mishura on 9/11/19.
//  Copyright © 2019 Bogdan Mishura. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    //MARK: - fetching news 
    func getNews(fromPage: String, url: String, completion: @escaping ([ArticlesModel]?) -> ()) {
        
        let urlWithPage = url + "&page=" + fromPage
        
        guard let url = URL(string: urlWithPage) else {return}
       
        URLSession.shared.dataTask(with: url) { data, response, error  in
        
        if let error = error {
            print(error.localizedDescription)
            completion(nil)
        } else if let data = data {
            
            let newsList = try? JSONDecoder().decode(NewsModel.self, from: data)
            completion(newsList?.articles)
            }
    }.resume()
    }
}
