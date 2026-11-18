//
//  TheaterModel.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import Foundation

struct Theater: Identifiable, Hashable {
    let id: String
    let name: String
    let area: String
    let distance: String
    let format: String
    let seatPrice: Int
    let showTimes: [String]
}

enum TheaterData {
    static let all: [Theater] = [
        Theater(
            id: "pvr-forum",
            name: "PVR Forum Mall",
            area: "Koramangala",
            distance: "2.1 km",
            format: "IMAX",
            seatPrice: 250,
            showTimes: ["10:00 AM", "1:30 PM", "4:30 PM", "7:30 PM", "10:30 PM"]
        ),
        Theater(
            id: "inox-garuda",
            name: "INOX Garuda Mall",
            area: "MG Road",
            distance: "4.3 km",
            format: "Dolby Atmos",
            seatPrice: 200,
            showTimes: ["11:00 AM", "2:15 PM", "6:00 PM", "9:15 PM"]
        ),
        Theater(
            id: "cinepolis-orion",
            name: "Cinépolis Orion Mall",
            area: "Rajajinagar",
            distance: "8.7 km",
            format: "4DX",
            seatPrice: 300,
            showTimes: ["10:30 AM", "1:00 PM", "4:00 PM", "7:00 PM", "10:00 PM"]
        ),
        Theater(
            id: "pvr-vr",
            name: "PVR VR Bengaluru",
            area: "Whitefield",
            distance: "15.2 km",
            format: "2D",
            seatPrice: 150,
            showTimes: ["9:45 AM", "12:45 PM", "3:45 PM", "6:45 PM", "9:45 PM"]
        )
    ]
}
