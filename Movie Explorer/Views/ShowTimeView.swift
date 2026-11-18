//
//  ShowTimeView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//



import SwiftUI

struct ShowTimeView: View {

    let movie: Movie
    let theater: Theater

    @State private var selectedDate = 0
    @State private var selectedTime: String? = nil

    private let dates = [
        "17 Nov", "18 Nov", "19 Nov",
        "20 Nov", "21 Nov"
    ]

    private let showTimes = [
        "10:00 AM",
        "1:30 PM",
        "4:30 PM",
        "7:00 PM",
        "10:00 PM"
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        VStack(alignment: .leading, spacing: 25) {

            Text(movie.title)
                .font(.title2.bold())

            Text("Select Date")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 10) {

                    ForEach(dates.indices, id: \.self) { index in

                        Button {

                            selectedDate = index

                        } label: {

                            Text(dates[index])
                                .font(.subheadline.bold())
                                .padding()
                                .background(
                                    selectedDate == index
                                    ? Color.purple
                                    : Color.gray.opacity(0.2)
                                )
                                .foregroundStyle(
                                    selectedDate == index
                                    ? .white : .primary
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 10)
                                )
                        }
                    }
                }
            }

            Text("Select Show Time")
                .font(.headline)

            LazyVGrid(columns: columns, spacing: 15) {

                ForEach(showTimes, id: \.self) { time in

                    Button {

                        selectedTime = time

                    } label: {

                        Text(time)
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                selectedTime == time
                                ? Color.purple
                                : Color.gray.opacity(0.2)
                            )
                            .foregroundStyle(
                                selectedTime == time
                                ? .white : .primary
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    }
                }
            }

            Spacer()
            
            Spacer()

            CustomBtn(title: "Select Seats", isEnabled: selectedTime != nil) {
                SeatSelectionView(
                    movie: movie, theater:theater ,
                    selectedDate: dates[selectedDate],
                    selectedTime: selectedTime ?? ""
                )
            }
            .disabled(selectedTime == nil)
        }
        .padding()
        .navigationTitle("Show Time")
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton()
    }
}



struct ShowTimeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ShowTimeView(
                movie: Movie(
                    id: 1,
                    title: "Inception",
                    overview: "A science fiction movie about dreams.",
                    posterPath: nil,
                    voteAverage: 8.8,
                    releaseDate: "2010-07-16"
                ),
                theater: TheaterData.all[0]
            )
        }
    }
}
