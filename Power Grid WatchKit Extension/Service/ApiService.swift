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
    static func fuelMix(startTime: String, endTime: String) -> AnyPublisher<FuelMix, Error> {
        let request = URLRequest(url: URL(string: "http://smartgriddashboard.eirgrid.com/DashboardService.svc/data?area=fuelmix&region=ALL&datefrom=\(startTime)&dateto=\(endTime)")!)
        return agent.run(request)
            .map(\.value)
            .print()
            .eraseToAnyPublisher()
    }
}

struct FuelMix: Decodable, Identifiable {
    let id: Int
    
    let errorMessage: String?
    let lastUpdated: Date
    let rows: [FuelMixRow]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id, lastUpdated = "LastUpdated"
        case errorMessage = "ErrorMessage"
        case rows = "Rows"
        case status = "Status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = 0
        errorMessage = try String(values.decodeIfPresent(String.self, forKey: .errorMessage) ?? "")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        lastUpdated = formatter.date(from: try String(values.decode(String.self, forKey: .lastUpdated)))!
        
        rows = try values.decode([FuelMixRow].self, forKey: .rows)
        status = try String(values.decode(String.self, forKey: .status))
    }
}

struct FuelMixRow: Decodable, Identifiable {
    let id: Int
    
    let effectiveTime: Date
    let fuelType: String
    let region: String
    let value: Double
    let color: Color
    
    enum CodingKeys: String, CodingKey {
        case id, effectiveTime = "EffectiveTime"
        case fuelType = "FieldName"
        case region = "Region"
        case value = "Value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        effectiveTime = formatter.date(from: try String(values.decode(String.self, forKey: .effectiveTime)))!
    
        fuelType = try String(values.decode(String.self, forKey: .fuelType))
        region = try String(values.decode(String.self, forKey: .region))
        value = try Double(values.decode(Double.self, forKey: .value))
        
        switch fuelType {
        case FuelType.coal.rawValue:
            id = 0
            color = Color(red: 143/255, green: 24/255, blue: 96/255)
        case FuelType.gas.rawValue:
            id = 1
            color = Color(red: 210/255, green: 94/255, blue: 21/255)
        case FuelType.netImport.rawValue:
            id = 2
            color = Color(red: 195/255, green: 22/255, blue: 50/255)
        case FuelType.otherFossil.rawValue:
            id = 3
            color = Color(red: 250/255, green: 182/255, blue: 0)
        case FuelType.renewable.rawValue:
            id = 4
            color = Color(red: 0, green: 99/255, blue: 115/255)
        default :
            id = -1
            color = Color.white
        }
    }
}

enum FuelType: String {
    case coal = "FUEL_COAL"
    case gas = "FUEL_GAS"
    case netImport = "FUEL_NET_IMPORT"
    case otherFossil = "FUEL_OTHER_FOSSIL"
    case renewable = "FUEL_RENEW"
}

enum Region: String {
    case all = "ALL"
    case ROI = "ROI"
    case NI = "NI"
}

enum Status: String {
    case error =  "Error"
    case success =  "Success"
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