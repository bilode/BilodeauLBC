//
//  OffersViewModel.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation

class OffersViewModel {
    
    let offersRepository: OffersRepository
    
    var offers: Dynamic<[Offer]>
    
    init(with offersRepository: OffersRepository) {
        self.offersRepository = offersRepository
        self.offers = Dynamic([])
    }
    
    public func fetchOffers() {
        self.offersRepository.getOffers()
    }
}
