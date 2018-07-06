//
//  ViewController.swift
//  BinanceTest
//
//  Created by MuRay Lin on 2018/7/5.
//  Copyright © 2018年 None. All rights reserved.
//

import UIKit
import MJLCategoryView

enum BinanceQuoteAsset: String {
    case bnb = "BNB"
    case btc = "BTC"
    case eth = "ETH"
    case usdt = "USDT"
    case Max = ""
}

class ViewController: UIViewController {
    var binanceInfoTableViews = [UITableView]()
    var originBinanceInfos = [BinanceInfo]()
    var groupedBinanceInfos = [[BinanceInfo]]()
    
    @IBOutlet weak var binanceInfoScrollView: UIScrollView!
    @IBOutlet weak var categoryView: MJLCategoryView! {
        didSet {
            var style = MJLCategoryStyle()
            style.titleNumberOfLine = 2
            style.backgroundColor = UIColor(hex: 0x202932)
            style.titleColor = UIColor.white
            style.selectedTitleColor = UIColor(red: 204, green: 173, blue: 104)
            style.HintBarColor = UIColor(red: 204, green: 173, blue: 104)
            style.widthType = .deviceWidth
            
            categoryView.categoryStyle = style
            categoryView.categoryTitles =
                [BinanceQuoteAsset.bnb.rawValue, BinanceQuoteAsset.btc.rawValue,
                 BinanceQuoteAsset.eth.rawValue, BinanceQuoteAsset.usdt.rawValue]
            categoryView.defaultSelectedButtonIndex = 0
            categoryView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setBinanceInfoScrollView()
        fetchBinanceInformation()
    }
    
    func setBinanceInfoScrollView() {
        
        guard binanceInfoTableViews.count == 0 else {
            return
        }
        
        for index in 0..<BinanceQuoteAsset.Max.hashValue {
            let tableView = UITableView(frame: CGRect(origin: CGPoint(x: binanceInfoScrollView.frame.width * CGFloat(index), y: 0), size: binanceInfoScrollView.frame.size))
            tableView.register(UINib(nibName: String(describing: BinanceInfoTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BinanceInfoTableViewCell.self))
            tableView.estimatedRowHeight = 64
            tableView.backgroundColor = UIColor.black
            tableView.separatorColor = UIColor.white.withAlphaComponent(0.5)
            tableView.dataSource = self
            tableView.tag = index
            
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = UIColor.white
            refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
            refreshControl.addTarget(self, action: #selector(pullDownToReload), for: .valueChanged)
            
            tableView.refreshControl = refreshControl
            
            binanceInfoScrollView.addSubview(tableView)
            binanceInfoTableViews.append(tableView)
        }
        binanceInfoScrollView.isPagingEnabled = true
        binanceInfoScrollView.contentSize = CGSize(width: binanceInfoScrollView.frame.width * CGFloat(BinanceQuoteAsset.Max.hashValue), height: binanceInfoScrollView.frame.width)
    }

    func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0x202932)
    }
    
    @objc func pullDownToReload() {
        fetchBinanceInformation()
    }
    
    func fetchBinanceInformation() {
        lockUserInteraction()
        let url = URL(string: "https://www.binance.com/exchange/public/product")
        let task = URLSession.shared.dataTask(with: url!) { [weak self] (data, response, error) in
            guard error == nil else {
                self?.reloadTableViews()
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let responseDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                
                guard let jsonObject = responseDict["data"] else {
                    self?.reloadTableViews()
                    return
                }
                let data =  try JSONSerialization.data(withJSONObject:jsonObject, options: .prettyPrinted)
                self?.originBinanceInfos = try jsonDecoder.decode([BinanceInfo].self, from: data)
                self?.groupBinanceInfo()
                
                self?.reloadTableViews()
            } catch let parseError as NSError {
                self?.reloadTableViews()
                print("JSON Error \(parseError.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func groupBinanceInfo() {
        groupedBinanceInfos.removeAll()
        for _ in 0..<BinanceQuoteAsset.Max.hashValue {
            groupedBinanceInfos.append([BinanceInfo]())
        }
        
        for binanceInfo in originBinanceInfos {
            if let quoteAsset = binanceInfo.quoteAsset, let asset = BinanceQuoteAsset(rawValue: quoteAsset)  {
                groupedBinanceInfos[asset.hashValue].append(binanceInfo)
            }
        }
    }
    
    func reloadTableViews() {
        DispatchQueue.main.async {
            for tableView in self.binanceInfoTableViews {
                self.unlockUserInteraction()
                tableView.refreshControl?.endRefreshing()
                tableView.reloadData()
            }
        }
    }
}

// MARK: - Navigation
extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil, segue.identifier == "toSearchViewController" {
            let destVC = segue.destination as! SearchViewController
            destVC.originBinanceInfos = self.originBinanceInfos
        }
    }
}

// MARK: - Lock
extension ViewController {
    func lockUserInteraction() {
        binanceInfoScrollView.isUserInteractionEnabled = false
        categoryView.isUserInteractionEnabled = false
    }
    
    func unlockUserInteraction() {
        binanceInfoScrollView.isUserInteractionEnabled = true
        categoryView.isUserInteractionEnabled = true
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BinanceInfoTableViewCell.self), for: indexPath) as! BinanceInfoTableViewCell
        cell.setBinanceInfoTableViewCellWith(BinanceInfo: groupedBinanceInfos[tableView.tag][indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView.tag < groupedBinanceInfos.count else {
            return 0
        }
        return groupedBinanceInfos[tableView.tag].count
    }
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / self.view.frame.width)
        categoryView.selectCategoryAt(index: index)
    }
}

// MARK: - MJLCategoryViewDelegate
extension ViewController: MJLCategoryViewDelegate {
    func showCurrentCategoryWith(_ index: Int) {
        binanceInfoScrollView.setContentOffset(CGPoint(x: binanceInfoScrollView.frame.width * CGFloat(index), y: 0), animated: true)
    }
}

