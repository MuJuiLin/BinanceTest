//
//  BinanceInfo.swift
//  BinanceTest
//
//  Created by MuRay Lin on 2018/7/5.
//  Copyright © 2018年 None. All rights reserved.
//

import Foundation
struct BinanceInfo : Codable {
	let symbol : String?
	let quoteAssetName : String?
	let tradedMoney : Double?
	let baseAssetUnit : String?
	let baseAssetName : String?
	let baseAsset : String?
	let tickSize : String?
	let prevClose : Double?
	let activeBuy : Int?
	let high : String?
	let lastAggTradeId : Int?
	let low : String?
	let matchingUnitType : String?
	let close : String?
	let quoteAsset : String?
	let productType : String?
	let active : Bool?
	let minTrade : Double?
	let activeSell : Double?
	let withdrawFee : String?
	let volume : String?
	let decimalPlaces : Int?
	let quoteAssetUnit : String?
	let open : String?
	let status : String?
	let minQty : Double?

	enum CodingKeys: String, CodingKey {

		case symbol = "symbol"
		case quoteAssetName = "quoteAssetName"
		case tradedMoney = "tradedMoney"
		case baseAssetUnit = "baseAssetUnit"
		case baseAssetName = "baseAssetName"
		case baseAsset = "baseAsset"
		case tickSize = "tickSize"
		case prevClose = "prevClose"
		case activeBuy = "activeBuy"
		case high = "high"
		case lastAggTradeId = "lastAggTradeId"
		case low = "low"
		case matchingUnitType = "matchingUnitType"
		case close = "close"
		case quoteAsset = "quoteAsset"
		case productType = "productType"
		case active = "active"
		case minTrade = "minTrade"
		case activeSell = "activeSell"
		case withdrawFee = "withdrawFee"
		case volume = "volume"
		case decimalPlaces = "decimalPlaces"
		case quoteAssetUnit = "quoteAssetUnit"
		case open = "open"
		case status = "status"
		case minQty = "minQty"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
		quoteAssetName = try values.decodeIfPresent(String.self, forKey: .quoteAssetName)
		tradedMoney = try values.decodeIfPresent(Double.self, forKey: .tradedMoney)
		baseAssetUnit = try values.decodeIfPresent(String.self, forKey: .baseAssetUnit)
		baseAssetName = try values.decodeIfPresent(String.self, forKey: .baseAssetName)
		baseAsset = try values.decodeIfPresent(String.self, forKey: .baseAsset)
		tickSize = try values.decodeIfPresent(String.self, forKey: .tickSize)
		prevClose = try values.decodeIfPresent(Double.self, forKey: .prevClose)
		activeBuy = try values.decodeIfPresent(Int.self, forKey: .activeBuy)
		high = try values.decodeIfPresent(String.self, forKey: .high)
		lastAggTradeId = try values.decodeIfPresent(Int.self, forKey: .lastAggTradeId)
		low = try values.decodeIfPresent(String.self, forKey: .low)
		matchingUnitType = try values.decodeIfPresent(String.self, forKey: .matchingUnitType)
		close = try values.decodeIfPresent(String.self, forKey: .close)
		quoteAsset = try values.decodeIfPresent(String.self, forKey: .quoteAsset)
		productType = try values.decodeIfPresent(String.self, forKey: .productType)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		minTrade = try values.decodeIfPresent(Double.self, forKey: .minTrade)
		activeSell = try values.decodeIfPresent(Double.self, forKey: .activeSell)
		withdrawFee = try values.decodeIfPresent(String.self, forKey: .withdrawFee)
		volume = try values.decodeIfPresent(String.self, forKey: .volume)
		decimalPlaces = try values.decodeIfPresent(Int.self, forKey: .decimalPlaces)
		quoteAssetUnit = try values.decodeIfPresent(String.self, forKey: .quoteAssetUnit)
		open = try values.decodeIfPresent(String.self, forKey: .open)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		minQty = try values.decodeIfPresent(Double.self, forKey: .minQty)
	}

}
