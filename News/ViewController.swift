//
//  ViewController.swift
//  News
//
//  Created by Bogdan Mishura on 9/11/19.
//  Copyright © 2019 Bogdan Mishura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var newsListVM: NewsListViewModel!
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setup()
        
    }
    
    private func setup() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        NetworkManager.shared.getNews { (articles) in
            if let articles = articles {
                self.newsListVM = NewsListViewModel(articles: articles)
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as?  MyTableViewCell else {
            fatalError("MyCell not found")
        }
        
        let newsVM = self.newsListVM.articleAtIndex(indexPath.row)
        cell.configure(for: newsVM)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.newsListVM == nil ? 0 : self.newsListVM.numberOfSection
    }
    
    
}
