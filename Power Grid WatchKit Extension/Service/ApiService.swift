//
//  ApiService.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 14/11/2021.
//

import Foundation
import SwiftUI
import Combine

enum ApiService {
  static let agent = ApiAgent()
}

extension ApiService {
  static func fuelMix(startTime: String, endTime: String) -> AnyPublisher<FuelMixResponse, Error> {
    let request = URLRequest(url: URL(string: "https://www.smartgriddashboard.com/DashboardService.svc/data?area=fuelmix&region=ALL&datefrom=\(startTime)&dateto=\(endTime)")!)
    return agent.run(request)
      .map(\.value)
      .print()
      .eraseToAnyPublisher()
  }
}



//extension DateFormatter {
//    static let fullISO8601: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        return formatter
//    }()
//}

//
//extension DateFormatter {
//    // 14-Nov-2021+23:59
//    static let serverFormat: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MMM-yyyy+HH:mm"
//        formatter.calendar = Calendar(identifier: .gregorian)
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.locale = Locale(identifier: "en_IE")
//        return formatter
//    }()
//}
