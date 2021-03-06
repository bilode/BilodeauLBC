//
//  Category.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

struct Category: Decodable {
    let id: Int64
    let name: String
    
    init(id: Int64, name: String) {
        self.id = id
        self.name = name
    }
}
