//
//  APOD.swift
//  NasaAPOD
//
//  Created by Shivakumar, Sushma on 10/12/22.
//

import Foundation

// MARK: - Astronomy Picture of the Day Model
struct APOD: Codable {
    let date, explanation: String
    let hdurl, serviceVersion: String?
    let mediaType, title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

struct APODError: Codable {
    let code: Int
    let message: String
    let serviceVersion: String
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "msg"
        case serviceVersion = "service_version"
    }
}
