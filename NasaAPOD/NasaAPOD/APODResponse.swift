//
//  APODResponse.swift
//  NasaAPOD
//
//  Created by Saran on 4/15/22.
//

import Foundation

struct APODResponse: Codable {
    var date: String
    var title: String
    var url: String
    var media_type: String
    var explanation: String
    
    init(date: String, title: String, url: String, media_type: String, explanation: String){
        self.date = date
        self.title = title
        self.url = url
        self.media_type = media_type
        self.explanation = explanation
    }
    
}
