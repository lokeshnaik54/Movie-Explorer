//
//  BookingHistoryViewModel.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import Foundation
class BookingHistoryViewModel: ObservableObject {

    @Published var bookings: [BookingRecord] = [] {
        didSet { save() }
    }

    private let key = "SavedBookings"

    init() { load() }

    func add(_ booking: BookingRecord) {
        bookings.insert(booking, at: 0)   // newest first
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(bookings) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([BookingRecord].self, from: data)
        else { return }
        bookings = saved
    }
}
