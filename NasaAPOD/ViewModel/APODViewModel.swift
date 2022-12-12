//
//  APODNetwork.swift
//  NasaAPOD
//
//  Created by Shivakumar, Sushma on 10/12/22.
//

import Foundation

class APODViewModel: ObservableObject{
    @Published var apod = APOD(date: "", explanation: "", hdurl: "", serviceVersion: "", mediaType: "", title: "", url: "")
    
    func loadData(date: String, completion: @escaping ((Bool, String?) -> Void)) {
        print("https://api.nasa.gov/planetary/apod?api_key=\(Constants.API_KEY)&date=\(date)")
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(Constants.API_KEY)&date=\(date)") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let model = try! JSONDecoder().decode(APODError.self, from: data!)
                DispatchQueue.main.async {
                    self.apod = APOD(date: date, explanation: "", hdurl: "", serviceVersion: "", mediaType: "", title: "", url: "")
                    completion(false, model.message)
                }
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let model = try! JSONDecoder().decode(APOD.self, from: data!)
                DispatchQueue.main.async {
                    self.apod = model
                    completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.apod = APOD(date: date, explanation: "", hdurl: "", serviceVersion: "", mediaType: "", title: "", url: "")
                    completion(false, error?.localizedDescription)
                }
            }
        }.resume()
    }
}
