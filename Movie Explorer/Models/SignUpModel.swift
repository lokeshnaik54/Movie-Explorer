//
//  SignUpModel.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import Foundation

struct AppUser: Codable, Identifiable {
    let id: UUID
    var name: String
    let email: String
    let salt: String
    let passwordHash: String
}
