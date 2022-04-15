//
//  NetworkCalls.swift
//  WeatherApp
//
//  Created by Saran on 4/8/22.
//

import Foundation

class NetworkCalls {
    
    private let apiKey = "sMb4iqgQQFhww3hZiv8BwcsCDyjzF97kzjGZMnJa"
    
    public func getLatestImage(completionHandler: @escaping (APODResponse?) -> Void){
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(self.apiKey)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let apiCallTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Get Today's Image API \(error)")
                completionHandler(nil)
            }
            if let data = data {
                do{
                    let jsonObject = try JSONDecoder().decode(APODResponse.self, from: data)
                    completionHandler(jsonObject)
                }
                catch {
                    print(error)
                }
            }
        }
        apiCallTask.resume()
    }
    
    public func getImageByDate(date: String, completionHandler: @escaping (APODResponse?) -> Void){
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(self.apiKey)&date=\(date)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let apiCallTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Get Today's Image API \(error)")
                completionHandler(nil)
            }
            if let data = data {
                do{
                    let jsonObject = try JSONDecoder().decode(APODResponse.self, from: data)
                    completionHandler(jsonObject)
                }
                catch {
                    print(error)
                }
            }
        }
        apiCallTask.resume()
    }
    
//    func getWeatherFromLocationKey(key: String, completionHandler: @escaping ([WeatherDTO]?) -> Void){
//        let url = URL(string: "http://dataservice.accuweather.com/currentconditions/v1/\(key)?apikey=\(self.apiKey)")
//        var request = URLRequest(url: url!)
//        request.httpMethod = "GET"
//        let apiCallTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Get Popular Cities API \(error)")
//                completionHandler(nil)
//            }
//            if let data = data {
//                do{
//                    print(try JSONSerialization.jsonObject(with: data, options: []))
//                    let jsonObject = try JSONDecoder().decode([WeatherDTO].self, from: data)
//                    completionHandler(jsonObject)
//                }
//                catch {
//                    print(error)
//                }
//            }
//        }
//        apiCallTask.resume()
//    }
    
//    func getWeatherFromLatLong(lat: String, long: String, completionHandler: @escaping ([WeatherDTO]?, PopularCitiesDTO?) -> Void){
//        let url = URL(string: "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=\(self.apiKey)&q=\(lat)%2C\(long)")
//        var request = URLRequest(url: url!)
//        request.httpMethod = "GET"
//        let apiCallTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Get Location Key from Lat Long API \(error)")
//                completionHandler(nil, nil)
//            }
//            if let data = data {
//                do{
//                    let jsonObject = try JSONDecoder().decode(PopularCitiesDTO.self, from: data)
////                    completionHandler(jsonObject)
//                    self.getWeatherFromLocationKey(key: jsonObject.Key){weather in
//                        completionHandler(weather, jsonObject)
//                    }
//                }
//                catch {
//                    print(error)
//                }
//            }
//        }
//        apiCallTask.resume()
//    }
    
//    func getCityNamesFromSearch(searchTerm: String, completionHandler: @escaping ([PopularCitiesDTO]?) -> Void) {
//        let url = URL(string: "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=\(self.apiKey)&q=\(searchTerm)")
//        var request = URLRequest(url: url!)
//        request.httpMethod = "GET"
//        let apiCallTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Get Search Results API \(error)")
//                completionHandler(nil)
//            }
//            if let data = data {
//                do {
//                    let jsonObject = try JSONDecoder().decode([PopularCitiesDTO].self, from: data)
//                    completionHandler(jsonObject)
//                }
//                catch {
//                    print(error)
//                }
//            }
//        }
//        apiCallTask.resume()
//    }
    
}
