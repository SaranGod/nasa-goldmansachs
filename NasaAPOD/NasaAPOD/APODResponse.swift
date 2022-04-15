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
}
