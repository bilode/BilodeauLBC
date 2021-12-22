//
//  OfferDetailsViewModel.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation

class OfferDetailsViewModel {
    
    let categoryName: String
    let creationDate: String
    let description: String
    let isUrgent: String?
    let price: String?
    
    init(from offer: Offer, ofCategory category: Category) {
        
        self.categoryName = category.name
        self.description = offer.description
        self.creationDate = Self.formatter.string(from: offer.creationDate)
        self.isUrgent = offer.isUrgent ? "Urgent" : nil
        self.price = String(format: "%.2f €", offer.price)
    }
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
