//
//  ViewController.swift
//  News
//
//  Created by Bogdan Mishura on 9/11/19.
//  Copyright © 2019 Bogdan Mishura. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    private var newsListVM: NewsListViewModel!
    
    var refreshControl: UIRefreshControl?
    
    @IBOutlet weak var myTableView: UITableView!
    
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        fetchData(fromPage: page)
        addrefreshControl()
     
    }
    
    private func fetchData(fromPage: Int) {
        
        NetworkManager.shared.getNews(fromPage: String(fromPage)) { (articles) in
            if let articles = articles {
                self.newsListVM = NewsListViewModel(articles: articles)
                print(self.newsListVM.articles.count)

                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
        
    }
    private func fetchFromNextPage(page: Int) {
        NetworkManager.shared.getNews(fromPage: String(page)) { (articles) in
            if let articles = articles {
                self.newsListVM.articles += articles
                print(self.newsListVM.articles.count)
                
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
        
    }
    
        
    
    
    func addrefreshControl() {
        refreshControl = UIRefreshControl()
        myTableView.tableFooterView = UIView(frame: .zero)
        refreshControl?.addTarget(self, action: #selector(refreshTableView(sender:)), for: .valueChanged)
        myTableView.refreshControl = refreshControl

    }
    
    @objc func refreshTableView(sender: UIRefreshControl) {
        newsListVM = nil
        page = 1
        fetchData(fromPage: page)
        myTableView.reloadData()
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func showSafariVC(url: String) {
        let url = URL(string: url)
        if let urlForWeb = url {
        let webVC = SFSafariViewController(url: urlForWeb)
        present(webVC, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsListVM.articles.count - 1 {
            page += 1
            print(page)
            fetchFromNextPage(page: page)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlForSafari = newsListVM.articles[indexPath.row].url
        if urlForSafari != nil {
            showSafariVC(url: urlForSafari!)
        }
    }
}
