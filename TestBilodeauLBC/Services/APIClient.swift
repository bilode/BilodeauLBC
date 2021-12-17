//
//  APIClient.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation

class APIClient {
    
    func fetchOffers(_ completion: @escaping (Result<Data, Error>) -> Void) {
        
        let url = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
//            let decoded = try! JSONDecoder().decode(Offer.self, from: data!)
            completion(.success(data!))
        }.resume()
    }
}
