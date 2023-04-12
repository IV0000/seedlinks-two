//
//  Message.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 12/04/2023.
//

import Foundation


struct Message: Identifiable {
    let id: String = UUID().uuidString
    let userId: String = UUID().uuidString
    let text: String
    let time: Date
    let location: Location
    let personal: Bool
    let address: String
}
