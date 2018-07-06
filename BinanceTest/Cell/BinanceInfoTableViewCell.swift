//
//  BinanceInfoTableViewCell.swift
//  BinanceTest
//
//  Created by MuRay Lin on 2018/7/6.
//  Copyright © 2018年 None. All rights reserved.
//

import UIKit

class BinanceInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var baseAssetLabel: UILabel!
    @IBOutlet weak var quoteAssetLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var tradedMoneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBinanceInfoTableViewCellWith(BinanceInfo binanceInfo: BinanceInfo) {
        baseAssetLabel.text = binanceInfo.baseAsset
        quoteAssetLabel.text = binanceInfo.quoteAsset
        volumeLabel.text = binanceInfo.volume
        openLabel.text = binanceInfo.open
        tradedMoneyLabel.text = "\(binanceInfo.tradedMoney ?? 0.0)"
    }
}
