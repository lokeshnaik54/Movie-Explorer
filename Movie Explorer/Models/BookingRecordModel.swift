//
//  BookingRecordModel.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import SwiftUI

struct BookingRecord: Identifiable, Codable {
    let id: String
    let movieTitle: String
    let posterPath: String?
    let date: String
    let time: String
    let seats: [String]
    let totalAmount: Int
    var theaterName: String? = nil      
    var bookedAt: Date = Date()
}
