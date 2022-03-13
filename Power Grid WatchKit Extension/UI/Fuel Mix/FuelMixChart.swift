//
//  FuelMixChart.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 13/03/2022.
//

import SwiftUI
import SwiftUICharts

struct FuelMixChart: View {
  @ObservedObject var viewModel: MainViewModel
  let cgSize: CGSize
  
  var body: some View {
    PieChartView(
      data: viewModel.fuelMix.map({ row in row.toPieChartData()}),
      style: ChartStyle(
        backgroundColor: Color.black,
        accentColor: Color.black,
        secondGradientColor: Colors.OrangeStart,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray),
      form: cgSize,
      dropShadow: false)
  }
}

struct FuelMixChart_Previews: PreviewProvider {
  static var previews: some View {
    GeometryReader { geo in
      FuelMixChart(
        viewModel: MainViewModel(),
        cgSize: CGSize(width: geo.size.width, height: geo.size.height)
      )
    }
  }
}
