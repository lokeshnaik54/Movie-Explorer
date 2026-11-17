//
//  BookingSummaryView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import SwiftUI

struct BookingSummaryView: View {

    let movie: Movie
    let selectedSeats: [String]
    let selectedDate: String
    let selectedTime: String

    private let seatPrice = 150
    private let convenienceFee = 30

    @State private var isProcessing = false
    @State private var goToConfirmation = false
    @State private var showConfirmation = false
    @State private var savedBooking: BookingRecord?
    @EnvironmentObject var historyViewModel: BookingHistoryViewModel
    private var ticketAmount: Int {
        selectedSeats.count * seatPrice
    }

    private var totalAmount: Int {
        ticketAmount + convenienceFee
    }

    private var seatsText: String {
        selectedSeats.joined(separator: ", ")
    }

    private var ticketsText: String {
        "\(selectedSeats.count) × ₹\(seatPrice)"
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 25) {
            Text("Booking Summary")
                .font(.largeTitle.bold())

            summaryCard

            Spacer()

            PrimaryButton(title: "Confirm Booking - ₹\(totalAmount)") {
                showConfirmation = true
            }
        }
        .padding()
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton()
        .navigationDestination(isPresented: $goToConfirmation) {
            confirmationDestination
        }
        .overlay {
            if isProcessing {
                CustomLoaderView()
            }
        }
        .customAlert(
            isPresented: $showConfirmation,
            icon: "ticket.fill",
            iconColor: .purple,
            title: "Confirm Booking?",
            message: "You are booking \(selectedSeats.count) seat(s) for ₹\(totalAmount).",
            primaryTitle: "Confirm",
            primaryAction: { processBooking() },
            secondaryTitle: "Cancel"
        )
    }

 
        

    private func processBooking() {
        isProcessing = true
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)

            let booking = BookingRecord(
                id: String(UUID().uuidString.prefix(8)),
                movieTitle: movie.title,
                posterPath: movie.posterPath,
                date: selectedDate,
                time: selectedTime,
                seats: selectedSeats,
                totalAmount: totalAmount
            )

            historyViewModel.add(booking)
            savedBooking = booking
            isProcessing = false
            goToConfirmation = true
        }
    }
    

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            movieHeader
            Divider()
            showDetails
            Divider()
            priceDetails
            Divider()
            totalRow
        }
        .padding()
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private var movieHeader: some View {
        Text(movie.title)
            .font(.title2.bold())
    }

    private var showDetails: some View {
        VStack(alignment: .leading, spacing: 15) {
            summaryRow("Date", value: selectedDate)
            summaryRow("Show Time", value: selectedTime)
            summaryRow("Seats", value: seatsText)
        }
    }

    private var priceDetails: some View {
        VStack(alignment: .leading, spacing: 15) {
            summaryRow("Tickets", value: ticketsText)
            summaryRow("Ticket Amount", value: "₹\(ticketAmount)")
            summaryRow("Convenience Fee", value: "₹\(convenienceFee)")
        }
    }

    private var totalRow: some View {
        HStack {
            Text("Total Amount")
                .font(.headline)

            Spacer()

            Text("₹\(totalAmount)")
                .font(.title2.bold())
                .foregroundStyle(.purple)
        }
    }


    @ViewBuilder
    private var confirmationDestination: some View {
        if let savedBooking {
            BookingConfirmationView(booking: savedBooking)
        }
    }

    private var confirmLabel: some View {
        
        Text("Confirm Booking - ₹\(totalAmount)")
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.purple)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Helpers

    private func summaryRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct BookingSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BookingSummaryView(
                movie: Movie(
                    id: 1,
                    title: "Inception",
                    overview: "A science fiction movie about dreams.",
                    posterPath: nil,
                    voteAverage: 8.8,
                    releaseDate: "2010-07-16"
                ),
                selectedSeats: ["A1", "A2"],
                selectedDate: "17 Nov 2026",
                selectedTime: "7:30 PM"
            )
        }
    }
}
