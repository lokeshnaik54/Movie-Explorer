//
//  SeatSelectionView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//


import SwiftUI

struct SeatSelectionView: View {

    let movie: Movie
    let selectedDate: String
    let selectedTime: String

    @State private var selectedSeats: Set<String> = []

    private let rows = ["A", "B", "C", "D", "E"]
    private let seatNumbers = 1...6

    private let bookedSeats: Set<String> = [
        "A2", "A3", "B4", "C1", "D5"
    ]

    private let seatPrice = 150

    var body: some View {

        VStack(spacing: 25) {

            Text(movie.title)
                .font(.title2.bold())

            Text("SCREEN")
                .font(.caption.bold())
                .tracking(5)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 15))

            VStack(spacing: 15) {

                ForEach(rows, id: \.self) { row in

                    HStack(spacing: 12) {

                        Text(row)
                            .font(.caption.bold())

                        ForEach(seatNumbers, id: \.self) { number in

                            let seat = "\(row)\(number)"

                            Button {

                                if !bookedSeats.contains(seat) {

                                    if selectedSeats.contains(seat) {
                                        selectedSeats.remove(seat)
                                    } else {
                                        selectedSeats.insert(seat)
                                    }
                                }

                            } label: {

                                Text("\(number)")
                                    .font(.caption.bold())
                                    .frame(width: 35, height: 35)
                                    .background(seatColor(seat))
                                    .foregroundStyle(.white)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 8)
                                    )
                            }
                            .disabled(bookedSeats.contains(seat))
                        }
                    }
                }
            }

            HStack(spacing: 20) {

                legend(color: .green, title: "Available")
                legend(color: .purple, title: "Selected")
                legend(color: .gray, title: "Booked")
            }
            .font(.caption)

            Spacer()

            HStack {

                VStack(alignment: .leading) {

                    Text("Selected Seats")
                        .font(.caption)

                    Text(
                        selectedSeats.isEmpty
                        ? "None"
                        : selectedSeats.sorted().joined(separator: ", ")
                    )
                    .font(.headline)
                }

                Spacer()

                VStack(alignment: .trailing) {

                    Text("Total Price")
                        .font(.caption)

                    Text("₹\(selectedSeats.count * seatPrice)")
                        .font(.title3.bold())
                }
            }
            CustomBtn(title: "Continue", isEnabled: !selectedSeats.isEmpty,destination: {
                BookingSummaryView(
                    movie: movie,
                    selectedSeats: Array(selectedSeats).sorted(),
                    selectedDate: selectedDate,
                    selectedTime: selectedTime
                )
            })
        }
        .padding()
        .navigationTitle("Select Seats")
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton()
    }

    private func seatColor(_ seat: String) -> Color {

        if bookedSeats.contains(seat) {
            return .gray
        }

        if selectedSeats.contains(seat) {
            return .purple
        }

        return .green
    }

    private func legend(color: Color, title: String) -> some View {

        HStack(spacing: 5) {

            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 12, height: 12)

            Text(title)
        }
    }
}



struct SeatSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SeatSelectionView(movie: Movie(
            id: 1,
            title: "Inception",
            overview: "A science fiction movie about dreams.",
            posterPath: nil,
            voteAverage: 8.8,
            releaseDate: "2010-07-16"
        ), selectedDate: "", selectedTime: "")
    }
}
