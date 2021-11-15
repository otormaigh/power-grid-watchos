//
//  MainViewModel.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 14/11/2021.
//

import Foundation
import Combine
import SwiftUI
import SwiftUICharts

class MainViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = Set()
    @Published var fuelMix = [PieChartData]()
    @Published var lastUpdated = ""
    
    init() {
        fetchFuelMix()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func fetchFuelMix() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let todayDate = formatter.string(from: Date())
        
        ApiService.fuelMix(startTime: "\(todayDate)+00:00", endTime: "\(todayDate)+23:59")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { fuelMixResponse in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MMM HH:mm"
                    
                    self.lastUpdated = formatter.string(from: fuelMixResponse.rows[0].effectiveTime)
                    self.fuelMix.append(contentsOf: fuelMixResponse.rows
                                            .sorted(by: { first, second in first.id < second.id })
                                            .map({ FuelMixRow in
                        PieChartData(value: FuelMixRow.value, color: FuelMixRow.color)
                    }))
                }
            ).store(in : &cancellables)
    }
}
