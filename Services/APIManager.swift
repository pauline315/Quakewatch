//
//  APIManager.swift
//  quakealert
//
//  Created by EMTECH MAC on 03/07/2024.
//
import Foundation

class APIManager {
    static let shared = APIManager()

    func fetchEarthquakeData(completion: @escaping ([Earthquake]) -> Void) {
        let urlString = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(EarthquakeResponse.self, from: data)
                    let earthquakes = response.features.map { $0.properties }
                    completion(earthquakes)
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}
