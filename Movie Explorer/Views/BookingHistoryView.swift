//
//  BookingHistoryView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import SwiftUI

struct BookingHistoryView: View {

    @EnvironmentObject var historyViewModel: BookingHistoryViewModel

    var body: some View {
        Group {
            if historyViewModel.bookings.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .navigationTitle("My Bookings")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Spacer()
            Image(systemName: "ticket")
                .font(.system(size: 65))
                .foregroundStyle(.secondary)
            Text("No Bookings Yet")
                .font(.title2.bold())
            Text("Your booked tickets will show up here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(historyViewModel.bookings) { booking in
                    NavigationLink {
                        BookingDetailView(booking: booking)
                    } label: {
                        BookingRow(booking: booking)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

private struct BookingRow: View {

    let booking: BookingRecord

    var body: some View {
        HStack(spacing: 14) {
            poster

            VStack(alignment: .leading, spacing: 6) {
                Text(booking.movieTitle)
                    .font(.headline)
                    .lineLimit(1)

                Text("\(booking.date) • \(booking.time)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("Seats: \(booking.seats.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "qrcode")
                .font(.title2)
                .foregroundStyle(.purple)
        }
        .padding(12)
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var poster: some View {
        AsyncImage(
            url: booking.posterPath.flatMap {
                URL(string: "\(Networking.imageBaseURL)\($0)")
            }
        ) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Rectangle().fill(Color.gray.opacity(0.2))
        }
        .frame(width: 60, height: 85)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct BookingHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        BookingHistoryView()
    }
}
