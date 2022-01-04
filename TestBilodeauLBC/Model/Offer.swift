//
//  Offer.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation

struct Offer: Decodable {
    
    let id: Int64
    let categoryId: Int64
    let creationDate: Date
    let description: String
    let isUrgent: Bool
    let imagesURL: ImagesURL
    let price: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case creationDate = "creation_date"
        case description
        case isUrgent = "is_urgent"
        case imagesURL = "images_url"
        case price
    }
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int64.self, forKey: .id)
        self.categoryId = try container.decode(Int64.self, forKey: .categoryId)
        
        let stringDate = try container.decode(String.self, forKey: .creationDate)
        self.creationDate = Self.formatter.date(from: stringDate) ?? .distantFuture
        
        self.description = try container.decode(String.self, forKey: .description)
        self.isUrgent = try container.decode(Bool.self, forKey: .isUrgent)
        self.imagesURL = try container.decode(ImagesURL.self, forKey: .imagesURL)
        self.price = try container.decode(Double.self, forKey: .price)
    }
    
    // Only for testing purpose
    init(categoryID: Int64, creationDate: Date, description: String, isUrgent: Bool) {
        self.id = 0
        self.categoryId = categoryID
        self.creationDate = creationDate
        self.description = description
        self.isUrgent = isUrgent
        self.imagesURL = ImagesURL(small: nil, thumb: nil)
        self.price = 0
    }
}
