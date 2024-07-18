//
//  APIManager.swift
//  quakealert
//
//  Created by EMTECH MAC on 18/07/2024.
//

import Foundation
import RxSwift



class APIManager {
    func fetchAPI() -> Observable<[Earthquake]>{
        return Observable.create { observer in
            
            //
            
            
            let url = URL(string:"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!
            let task = URLSession.shared.dataTask(with: url){data,response,error in
                //
                
                
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let httpresponse = response as? HTTPURLResponse,(200...299).contains(httpresponse.statusCode)else{
                    observer.onError(NSError(domain: "Invalid Url", code: 0, userInfo: nil))
                    return
                }
                
                guard let data = data else {
                    observer.onError(NSError(domain: "ERROR OCCURED", code: 0, userInfo: nil))
                    return
                }
                
                do {
                    
                    let decodeddata = try JSONDecoder().decode(EarthquakeData.self, from: data)
                    
                    let finishedData = decodeddata.features.map{feature -> Earthquake in
                        return Earthquake(
                            id: feature.id,
                            mag: feature.properties.mag,
                            place: feature.properties.place,
                            time: feature.properties.time,
                            latitude: feature.geometry.coordinates[1],
                            longitude: feature.geometry.coordinates[0]
                        )
                    }
                    observer.onNext(finishedData)
                    observer.onCompleted()
                    
                }catch {
                    observer.onError(NSError(domain: "No data available", code: 0, userInfo: nil))
                }
               
            }
            task.resume()
            
              return Disposables.create{
                task.cancel()
            }
            
            
        }
        
    }
}
