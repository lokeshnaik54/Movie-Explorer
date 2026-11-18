//
//  TicketView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import SwiftUI

struct TicketCardView: View {

    let booking: BookingRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(booking.movieTitle)
                .font(.title2.bold())

            Divider()

            detailRows

            Divider()

            totalRow

            Divider()

            qrSection
        }
        .padding()
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var detailRows: some View {
        VStack(alignment: .leading, spacing: 18) {
            row("Booking ID", booking.id)
            if let theater = booking.theaterName {      // NEW
                row("Theater", theater)
            }
            row("Date", booking.date)
            row("Show Time", booking.time)
            row("Seats", booking.seats.joined(separator: ", "))
        }
    }

    private var totalRow: some View {
        HStack {
            Text("Total Amount")
                .font(.headline)
            Spacer()
            Text("₹\(booking.totalAmount)")
                .font(.title2.bold())
                .foregroundStyle(.purple)
        }
    }

    private var qrSection: some View {
        VStack(spacing: 10) {
            QRView(text: booking.id)
                .frame(width: 160, height: 160)
                .padding(10)
                .background(Color.white)   // white keeps it scannable in dark mode
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("Show this ticket at the cinema")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct BookingDetailView: View {

    let booking: BookingRecord

    var body: some View {
        ScrollView {
            TicketCardView(booking: booking)
                .padding()
        }
        .navigationTitle("Ticket")
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton()
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketCardView(booking: BookingRecord(id: "10", movieTitle: "Movie", posterPath: "sdj", date: " ", time: " ", seats: ["2","3"], totalAmount: 100))
    }
}
