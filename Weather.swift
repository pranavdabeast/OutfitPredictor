//
//  Weather.swift
//  Outfit Recommender
//
//  Created by Brian Advent- [Website]


import Foundation

struct Weather {
    let summary:String
    let apparentTemperature:Double
    
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let apparentTemperature = json["apparentTemperature"] as? Double else {throw SerializationError.missing("apparentTemperature is missing")}
        
        
        
        
        self.summary = summary
        self.apparentTemperature = apparentTemperature
                
    } //error messages and declarations for summary, tempHigh, and tempLow
    
    
    static let basePath = "https://api.darksky.net/forecast/c3b2b5cf5b4d050444e22e23f809fab4/"
    
    static func forecast (withLocation location: String, completion: @escaping ([Weather]) -> ()) {
        
        let url = basePath + location
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["hourly"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()

    }
}
