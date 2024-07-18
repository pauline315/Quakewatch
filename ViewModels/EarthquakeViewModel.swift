import Foundation

class EarthquakeViewModel {
    private var earthquakes: [Earthquake] = []

    var onUpdate: (() -> Void)?

    func fetchEarthquakeData() {
        APIManager.shared.fetchEarthquakeData { [weak self] data in
            self?.earthquakes = data
            self?.onUpdate?()
        }
    }

    var numberOfEarthquakes: Int {
        return earthquakes.count
    }

    func earthquake(at index: Int) -> Earthquake {
        return earthquakes[index]
    }

    
    var earthquakeList: [Earthquake] {
        return earthquakes
    }
}
