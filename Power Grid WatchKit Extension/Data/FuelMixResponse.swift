//
//  FuelMixResponse.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 13/03/2022.
//

import Foundation

struct FuelMixResponse: Decodable, Identifiable {
  let id: Int
  
  let errorMessage: String?
  let lastUpdated: Date
  let status: String
  let totalFuel: Double
  let rows: [FuelMixRow]
  
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
    formatter.locale = Locale(identifier: "en_IE")
    formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
    lastUpdated = formatter.date(from: try String(values.decode(String.self, forKey: .lastUpdated)))!
    
    status = try String(values.decode(String.self, forKey: .status))
    
    rows = try values.decode([FuelMixRow].self, forKey: .rows)
    totalFuel = rows.reduce(0, { partialResult, row in partialResult + row.value})
  }
}
