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
    @Published var fuelMix = [FuelMixRow]()
    @Published var lastUpdated = ""
    @Published var state = State.IDLE
    
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
        
        self.state = State.LOADING
        ApiService.fuelMix(startTime: "\(todayDate)+00:00", endTime: "\(todayDate)+23:59")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { fuelMixResponse in
                    self.state = State.LOADED
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MMM HH:mm"
                    
                    self.lastUpdated = formatter.string(from: fuelMixResponse.rows[0].effectiveTime)
                    self.fuelMix.append(
                        contentsOf:
                            fuelMixResponse.rows
                            .map({ row in FuelMixRow(row: row, totalFuel: fuelMixResponse.totalFuel) })
                            .sorted(by: { first, second in first.id < second.id }))
                }
            ).store(in : &cancellables)
    }
}

enum State {
    case IDLE
    case LOADING
    case LOADED
}

extension FuelMixRow {
    func toPieChartData() -> PieChartData {
        return PieChartData(value: self.value, color: self.color)
    }
}
