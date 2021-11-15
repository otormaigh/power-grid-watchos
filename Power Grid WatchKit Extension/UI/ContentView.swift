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
        GeometryReader { geo in
            ScrollView {
                VStack {
                    PieChartView(
                        data: viewModel.fuelMix,
                        style: ChartStyle(
                            backgroundColor: Color.black,
                            accentColor: Color.black,
                            secondGradientColor: Colors.OrangeStart,
                            textColor: Color.black,
                            legendTextColor: Color.gray,
                            dropShadowColor: Color.gray),
                        form: CGSize(width: geo.size.width, height: geo.size.height),
                        dropShadow: false)
                }.edgesIgnoringSafeArea(.all)
                
                Text("Last Updated: \(viewModel.lastUpdated)")
                    .font(.footnote)
                    .padding(.bottom, 30)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MainViewModel())
    }
}
