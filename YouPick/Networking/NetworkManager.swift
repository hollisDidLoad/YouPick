//
//  NetworkManager.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/14/22.
//

import Foundation
class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    let baseUrl = URL(string: "https://api.yelp.com/v3")
    let endPoint = "businesses/search"
    let apiKey = API_KEY().key
    
    func fetchBusinesses(
        limit: Int,
        location: String,
        attributes: String = "hot_and_new",
        completion: @escaping ([RestaurantModel]) -> Void
    ) {
        guard let url = baseUrl?.appending(path: endPoint) else { return }
        
        let queryItems = [
            "limit" : limit,
            "location" : location,
            "attributes": attributes
        ] as [String : Any]
        
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = queryItems.map {URLQueryItem(name: $0.key, value: $0.value as? String)}
        guard let finalUrl = urlComponent?.url else { return }
        var request = URLRequest(url: finalUrl)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode(RestaurantsAPIModel.self, from: data).restaurants
                    completion(jsonData)
                } catch {
                    print(error)
                }
            }
        }).resume()
    }
}
