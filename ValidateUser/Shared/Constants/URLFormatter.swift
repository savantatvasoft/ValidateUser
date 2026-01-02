//
//  URLFormatter.swift
//  ValidateUser
//
//  Created by MACM72 on 02/01/26.
//

import Foundation

struct URLFormatter {
    static func format(_ text: String?) -> URL? {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return nil
        }
        let prefix = text.lowercased().hasPrefix("http") ? "" : "https://"
        return URL(string: "\(prefix)\(text)")
    }
}
