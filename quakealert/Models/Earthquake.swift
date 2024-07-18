//
//  Earthquake.swift
//  quakealert
//
//  Created by EMTECH MAC on 18/07/2024.
//

import Foundation
import RxSwift

struct Earthquake{
    let id : String
    let mag: Double
    let place: String
    let time: Int64
    let latitude: Double
    let longitude: Double
}

struct EarthquakeData: Codable {
    let features : [features]
}

struct features : Codable{
    let properties : properties
    let id : String
    let geometry :geometry
}
struct properties: Codable{
    let mag : Double
    let place: String
    let time: Int64

}
struct geometry : Codable {
    let coordinates: [Double]
    
}

struct coordinates : Codable{
    let latitude : Double
    let longitude : Double
    
}


