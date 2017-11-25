//
//  ChartModel.swift
//  BarCharts
//
//  Created by Rostyslav Hetmaniuk on 11/25/17.
//  Copyright © 2017 Rostyslav Hetmaniuk. All rights reserved.
//

import Foundation
struct DataChart : Codable {
    let d1: [Pair]
    let h1: [Pair]
    let h4: [Pair]
    let lastCalcTime: Date
    let m15: [Pair]
    let symbolIndices: [SymbolIndex]
}

struct SymbolIndex: Codable {
    let strongWeakPair: String
    let strongest: String
    let timeFrame: String
    let weakest: String
}

struct Pair: Codable {
    let key: String
    let value: Double
}

extension DataChart {
    enum CodingKeys: String, CodingKey {
        case d1 = "D1"
        case h1 = "H1"
        case h4 = "H4"
        case lastCalcTime = "LastCalcTime"
        case m15 = "M15"
        case symbolIndices = "SymbolIndices"
    }
}

extension SymbolIndex {
    enum CodingKeys: String, CodingKey {
        case strongWeakPair = "StrongWeakPair"
        case strongest = "Strongest"
        case timeFrame = "TimeFrame"
        case weakest = "Weakest"
    }
}

extension Pair {
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case value = "Value"
    }
}
