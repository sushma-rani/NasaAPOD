//
//  Constants.swift
//  NasaAPOD
//
//  Created by Shivakumar, Sushma on 09/12/22.
//

import Foundation

public struct Constants {
    static let API_KEY = "mu4QCthmaqZnfXZ3K1QC0BfWhWehvxB9mz3MhR7N"
}

enum Fellix: String {
    case bold = "Fellix-Bold"
    case medium = "Fellix-Medium"
}

enum MediaType: String {
    case image = "image"
    case video = "video"
}

public struct AccessibilityIdentifiers {
    static let picOfTheDay = "viewTitle"
    static let datePicker = "datePicker"
    static let title = "apodTitle"
    static let message = "apodMessage"
    static let image = "image"
}
