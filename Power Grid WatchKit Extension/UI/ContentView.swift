//
//  ContentView.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 14/11/2021.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
  @ObservedObject var viewModel: MainViewModel
  
  var body: some View {
    FuelMixPage(viewModel: viewModel)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(viewModel: MainViewModel())
  }
}
