//
//  CityModel.swift
//  Weather
//
//  Created by Rimo Tech  on 4/29/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cityModel = try? JSONDecoder().decode(CityModel.self, from: jsonData)

import Foundation

// MARK: - CityModelElement
struct CityModelElement: Codable {
    let name: String
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {
        case name
        case lat, lon, country, state
    }
}

// MARK: - LocalNames
struct LocalNames: Codable {
    let be, ru, fr, cy: String
    let ko, he, en, mk: String
}

typealias CityModel = [CityModelElement]
