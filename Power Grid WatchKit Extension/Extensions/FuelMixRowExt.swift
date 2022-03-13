//
//  FuelMixRowExt.swift
//  Power Grid WatchKit Extension
//
//  Created by  on 13/03/2022.
//

import SwiftUICharts

extension FuelMixRow {
  func toPieChartData() -> PieChartData {
    return PieChartData(value: self.value, color: self.color)
  }
}
