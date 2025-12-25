//
//  Date+ToString.swift
//  ValidateUser
//
//  Created by MACM72 on 24/12/25.
//

import Foundation

extension Date {
    func toString(format: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
