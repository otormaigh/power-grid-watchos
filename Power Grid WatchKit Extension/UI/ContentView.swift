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
        ZStack {
            GeometryReader { geo in
                ScrollView {
                    VStack {
                        PieChartView(
                            data: viewModel.fuelMix.map({ row in row.toPieChartData()}),
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
                        .opacity(viewModel.state == State.LOADING ? 0 : 1)
                    
                    FuelMixList(fuelMix: viewModel.fuelMix, geo: geo)
                    
                    Text("\(String(localized: "last_updated")): \(viewModel.lastUpdated)")
                        .font(.footnote)
//                        .padding(.top, 10)
                        .padding(.bottom, 30)
                }
            }
            
            ProgressView()
                .opacity(viewModel.state == State.LOADED ? 0 : 1)
        }
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MainViewModel())
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
