//
//  OffersRepository.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation

class OffersRepository {
    
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getOffers() -> [Offer] {
        
        self.apiClient.fetchOffers { result in
            
            switch result {
            case .success(let data):
                print(data)
                let offers = try! JSONDecoder().decode([Offer].self, from: data)
                
                
                print("phiew")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return []
    }
}
