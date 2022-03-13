//
//  FuelMixList.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 13/03/2022.
//

import SwiftUI

struct FuelMixList: View {
  var fuelMix: [FuelMixRow]
  var geo: GeometryProxy
  
  var body: some View {
    List(fuelMix.sorted(by: { first, second in first.valuePercentage > second.valuePercentage })) { row in
      GeometryReader { geo in
        HStack {
          row.color
            .frame(width: geo.size.height / 2, height: geo.size.height)
            .cornerRadius(10, corners: [.topLeft, .bottomLeft])
            .padding(.leading, -10)
          
          Text("\(row.label): \(String(format: "%.2f", row.valuePercentage))%")
            .font(.footnote)
            .padding(.leading, 5)
        }
      }
    }.frame(width: geo.size.width, height: geo.size.height)
  }
}

struct FuelMixList_Previews: PreviewProvider {
  static var previews: some View {
    GeometryReader { geo in
      FuelMixList(fuelMix: [], geo: geo)
    }
  }
}
