//
//  FuelMixPage.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 13/03/2022.
//

import SwiftUI

struct FuelMixPage: View {
  @ObservedObject var viewModel: MainViewModel
  
  var body: some View {
    ZStack {
      GeometryReader { geo in
        ScrollView {
          VStack {
            FuelMixChart(
              viewModel: viewModel,
              cgSize: CGSize(width: geo.size.width, height: geo.size.height)
            )
          }
          .edgesIgnoringSafeArea(.all)
          .opacity(viewModel.state == State.LOADING ? 0 : 1)
          
          FuelMixList(fuelMix: viewModel.fuelMix, geo: geo)
          
          Text("\(String(localized: "last_updated")): \(viewModel.lastUpdated)")
            .font(.footnote)
            .padding(.bottom, 30)
        }
      }
      
      ProgressView()
        .opacity(viewModel.state == State.LOADED ? 0 : 1)
    }
  }
}

struct FuelMixPage_Previews: PreviewProvider {
  static var previews: some View {
    FuelMixPage(viewModel: MainViewModel())
  }
}
