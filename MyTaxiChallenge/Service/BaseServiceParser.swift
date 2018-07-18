//
//  BaseServiceParser.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/18/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import Foundation

class BaseServiceParser {
    
    func parseResponse<T:Codable>(response: Any, type: T.Type) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let parsedResponse = try decoder.decode(type, from: jsonData)
            return parsedResponse
        } catch {
            return nil
        }
    }
}
