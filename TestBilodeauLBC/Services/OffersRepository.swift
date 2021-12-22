//
//  OffersRepository.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation
import Combine

struct OffersRepository {
    
    let apiClient: Requestable
    private let url = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")!
    
    func getOffers() -> AnyPublisher<[Offer], Error> {
        return apiClient.make(URLRequest(url: self.url), JSONDecoder())
    }
}
