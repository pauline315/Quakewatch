//
//  Earthquake.swift
//  quakealert
//
//  Created by EMTECH MAC on 03/07/2024.
//

import Foundation

struct Earthquake: Codable, Identifiable {
    let id = UUID()
    let mag: Double
    let place: String
    let time: Int64
    let latitude: Double
    let longitude: Double

    private enum CodingKeys: String, CodingKey {
        case mag, place, time
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

struct EarthquakeResponse: Codable {
    let features: [Feature]

    struct Feature: Codable {
        let properties: Earthquake
    }
}
