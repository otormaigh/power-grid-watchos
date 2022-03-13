//
//  FuelMixRox.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 13/03/2022.
//

import SwiftUI

struct FuelMixRow: Decodable, Identifiable {
  let id: Int
  
  let effectiveTime: Date
  let fuelType: String
  let region: String
  let value: Double
  let valuePercentage: Double
  let color: Color
  let label: String
  
  enum CodingKeys: String, CodingKey {
    case id, effectiveTime = "EffectiveTime"
    case fuelType = "FieldName"
    case region = "Region"
    case value = "Value"
  }
  
  init(row: FuelMixRow, totalFuel: Double) {
    self.id = row.id
    self.effectiveTime = row.effectiveTime
    self.fuelType = row.fuelType
    self.region = row.region
    self.value = row.value
    self.valuePercentage = (self.value / totalFuel) * 100
    self.color = row.color
    self.label = row.label
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_IE")
    formatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
    effectiveTime = formatter.date(from: try String(values.decode(String.self, forKey: .effectiveTime)))!
    
    fuelType = try String(values.decode(String.self, forKey: .fuelType))
    region = try String(values.decode(String.self, forKey: .region))
    let tempValue = try Double(values.decode(Double.self, forKey: .value))
    if tempValue < 0 {
      value = tempValue * -1
    } else {
      value = tempValue
    }
    valuePercentage = -1
    
    switch fuelType {
      case FuelType.coal.rawValue:
        id = 0
        color = Color(red: 143/255, green: 24/255, blue: 96/255)
        label = String(localized: "fuel_type_coal")
      case FuelType.gas.rawValue:
        id = 1
        color = Color(red: 210/255, green: 94/255, blue: 21/255)
        label = String(localized: "fuel_type_gas")
      case FuelType.netImport.rawValue:
        id = 2
        color = Color(red: 195/255, green: 22/255, blue: 50/255)
        label = String(localized: "fuel_type_net_import")
      case FuelType.otherFossil.rawValue:
        id = 3
        color = Color(red: 250/255, green: 182/255, blue: 0)
        label = String(localized: "fuel_type_other")
      case FuelType.renewable.rawValue:
        id = 4
        color = Color(red: 0, green: 99/255, blue: 115/255)
        label = String(localized: "fuel_type_renewable")
      default :
        id = -1
        color = Color.white
        label = "Unknown"
    }
  }
}
