//
//  NetworkCalls.swift
//  WeatherApp
//
//  Created by Saran on 4/8/22.
//

import Foundation

class NetworkCalls {
    
    private let apiKey = "sMb4iqgQQFhww3hZiv8BwcsCDyjzF97kzjGZMnJa"
    
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
                    var jsonObject = try JSONDecoder().decode(APODResponse.self, from: data)
                    if jsonObject.media_type == "image"{
                        self.getImageFromURLInBase64(url: jsonObject.url) { base64 in
                            if base64 != nil {
                                jsonObject.url = base64!
                                completionHandler(jsonObject)
                            }
                            else {
                                completionHandler(nil)
                            }
                        }
                    }
                    else {
                        completionHandler(jsonObject)
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        apiCallTask.resume()
    }
    
    public func getImageFromURLInBase64(url: String, completionHandler: @escaping (String?) -> Void){
        let url = URL(string: url)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let apiCallTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Get Today's Image API \(error)")
                completionHandler(nil)
            }
            if let data = data {
                let base64String = data.base64EncodedString()
                completionHandler(base64String)
            }
        }
        apiCallTask.resume()
    }
}
