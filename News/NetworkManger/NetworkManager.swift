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
    
    func getNews(completion: @escaping ([ArticlesModel]?) -> ()) {
        
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=feb88f4f27b745f1a0838027633f1cf3") else {return}
       
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
