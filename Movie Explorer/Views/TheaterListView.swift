//
//  TheaterListView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import SwiftUI

struct TheaterListView: View {

    let movie: Movie

    @State private var pickedIndex = 0

    private let theaters = TheaterData.all

    
    private let dates: [Date] = {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return (0..<5).compactMap { cal.date(byAdding: .day, value: $0, to: today) }
    }()

    private let timeColumns = [
        GridItem(.adaptive(minimum: 92), spacing: 10)
    ]

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    // MARK: - Body

    var body: some View {
        // Re-evaluates every 30s so shows that start while the screen is open get disabled
        TimelineView(.periodic(from: .now, by: 30)) { context in
            content(now: context.date)
        }
        .navigationTitle("Select Theater")
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton()
    }

    private func content(now: Date) -> some View {
        let index = effectiveIndex(now: now)
        let day = dates[index]
        let dayText = day.formatted(.dateTime.day().month(.abbreviated))   // "18 Nov"

        return VStack(alignment: .leading, spacing: 16) {

            Text(movie.title)
                .font(.title2.bold())
                .lineLimit(2)
                .padding(.horizontal)

            dateStrip(selected: index, now: now)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(theaters) { theater in
                        theaterCard(theater, day: day, dayText: dayText, now: now)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .padding(.top)
    }

    // MARK: - Date logic

    /// Start time of a show on a given day, e.g. "7:30 PM" on 18 Nov -> 18 Nov 19:30
    private func showStart(_ time: String, on day: Date) -> Date? {
        guard let parsed = Self.timeFormatter.date(from: time) else { return nil }
        let cal = Calendar.current
        let parts = cal.dateComponents([.hour, .minute], from: parsed)
        return cal.date(
            bySettingHour: parts.hour ?? 0,
            minute: parts.minute ?? 0,
            second: 0,
            of: day
        )
    }

    private func isPast(_ time: String, on day: Date, now: Date) -> Bool {
        guard let start = showStart(time, on: day) else { return true }   // unparsable = not bookable
        return start <= now
    }

    /// A day is bookable if at least one theater still has an upcoming show
    private func hasShows(on day: Date, now: Date) -> Bool {
        theaters.contains { theater in
            theater.showTimes.contains { !isPast($0, on: day, now: now) }
        }
    }

    /// The picked date, or the first available date if the picked one has run out
    private func effectiveIndex(now: Date) -> Int {
        if hasShows(on: dates[pickedIndex], now: now) { return pickedIndex }
        return dates.indices.first { hasShows(on: dates[$0], now: now) } ?? pickedIndex
    }

    // MARK: - Date strip

    private func dateStrip(selected: Int, now: Date) -> some View {
        HStack(spacing: 6) {
            ForEach(dates.indices, id: \.self) { index in
                let date = dates[index]
                let isSelected = selected == index
                let available = hasShows(on: date, now: now)

                Button {
                    pickedIndex = index
                } label: {
                    VStack(spacing: 4) {
                        Text(date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2)
                        Text(date.formatted(.dateTime.day()))
                            .font(.headline)
                        Text(date.formatted(.dateTime.month(.abbreviated)))
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(isSelected ? Color.purple : Color.gray.opacity(0.2))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(available ? 1 : 0.35)
                }
                .buttonStyle(.plain)
                .disabled(!available)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Theater card

    private func theaterCard(_ theater: Theater, day: Date, dayText: String, now: Date) -> some View {
        let upcoming = theater.showTimes.filter { !isPast($0, on: day, now: now) }

        return VStack(alignment: .leading, spacing: 14) {

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(theater.name)
                        .font(.headline)

                    Label("\(theater.area) • \(theater.distance)", systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(theater.format)
                        .font(.caption2.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.15), in: Capsule())
                        .foregroundStyle(.purple)

                    Text("₹\(theater.seatPrice) / seat")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            if upcoming.isEmpty {
                Text("No more shows today")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: timeColumns, alignment: .leading, spacing: 10) {
                ForEach(theater.showTimes, id: \.self) { time in
                    timeChip(theater: theater, time: time, day: day, dayText: dayText, now: now)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private func timeChip(theater: Theater, time: String, day: Date, dayText: String, now: Date) -> some View {
        let past = isPast(time, on: day, now: now)

        if past {
            // Not a NavigationLink at all, so it can't be tapped
            chipLabel(time, past: true)
        } else {
            NavigationLink {
                SeatSelectionView(
                    movie: movie,
                    theater: theater,
                    selectedDate: dayText,
                    selectedTime: time
                )
            } label: {
                chipLabel(time, past: false)
            }
            .buttonStyle(.plain)
        }
    }

    private func chipLabel(_ time: String, past: Bool) -> some View {
        Text(time)
            .font(.subheadline.bold())
            .strikethrough(past)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .foregroundStyle(past ? Color.gray : Color.purple)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(past ? Color.gray.opacity(0.4) : Color.purple, lineWidth: 1)
            )
    }
}

struct TheaterListView_Previews: PreviewProvider {
    static var previews: some View {
        TheaterListView(movie: Movie(
            id: 1,
            title: "Inception",
            overview: "A science fiction movie about dreams.",
            posterPath: nil,
            voteAverage: 8.8,
            releaseDate: "2010-07-16"
        ))
    }
}
