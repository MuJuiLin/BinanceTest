//
//  SearchViewController.swift
//  BinanceTest
//
//  Created by MuRay Lin on 2018/7/6.
//  Copyright © 2018年 None. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 0))
    var originBinanceInfos = [BinanceInfo]()
    var filteredBinanceInfos = [BinanceInfo]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        
         tableView.register(UINib(nibName: String(describing: BinanceInfoTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BinanceInfoTableViewCell.self))
        
        filteredBinanceInfos = originBinanceInfos
    }

    override func viewDidAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        searchBar.tintColor = UIColor.black
        searchBar.enablesReturnKeyAutomatically = false
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BinanceInfoTableViewCell.self), for: indexPath) as! BinanceInfoTableViewCell
        cell.setBinanceInfoTableViewCellWith(BinanceInfo: filteredBinanceInfos[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBinanceInfos.count
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            filteredBinanceInfos = originBinanceInfos
        }
        else {
            filteredBinanceInfos = originBinanceInfos.filter({ (binanceInfo) -> Bool in
                let baseAsset = binanceInfo.baseAsset?.lowercased() ?? ""
                let quoteAsset = binanceInfo.quoteAsset?.lowercased() ?? ""
                
                if baseAsset.contains(searchText.lowercased()) || quoteAsset.contains(searchText.lowercased()) {
                    return true
                }
                else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
}
