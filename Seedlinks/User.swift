//
//  User.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 12/04/2023.
//

import Foundation

struct User: Identifiable {
    let id: String = UUID().uuidString
    var username: String
    let email: String
    let password: String
    var location: Location
    var messages: [UUID]
    var readMessages: [UUID]
}
