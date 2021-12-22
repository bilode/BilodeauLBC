//
//  ImagesURL.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation

struct ImagesURL: Decodable {
    let small: String?
    let thumb: String?
    
    private enum CodingKeys: String, CodingKey {
        case small
        case thumb
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.small = try? container.decode(String.self, forKey: .small)
        self.thumb = try? container.decode(String.self, forKey: .thumb)
    }
    
    init(small: String?, thumb: String?) {
        self.small = small
        self.thumb = thumb
    }
}
