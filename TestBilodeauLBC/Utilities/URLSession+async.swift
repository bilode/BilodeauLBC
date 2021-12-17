//
//  URLSession+async.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation

@available(iOS, deprecated: 15.0, message: "Use the build-in API instead")
extension URLSession {
    
//    func data(from url: URL) async throws -> Data {
//        return try await withCheckedThrowingContinuation { continuation in
//            let task = self.dataTask(with: url) { data, response, error in
//                guard let data = data, let response = response else {
//                    let error = error ?? URLError(.unknown)
//                    continuation.resume(throwing: error)
//                    return
//                }
//
//                return continuation.resume(returning: data)
//            }
//        }
//    }
}
