import SwiftUI

struct BookingConfirmationView: View {

    let booking: BookingRecord
    @Environment(\.goHome) private var goHome

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.green)

                Text("Booking Confirmed!")
                    .font(.largeTitle.bold())

                Text("Your movie tickets are ready.")
                    .foregroundStyle(.secondary)

                TicketCardView(booking: booking)

                PrimaryButton(title: "Go to Home", icon: "house.fill") {
                    goHome()
                }
            }
            .padding()
        }
        .navigationTitle("Your Ticket")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct BookingConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BookingConfirmationView(
                booking: BookingRecord(
                    id: "A1B2C3D4",
                    movieTitle: "Inception",
                    posterPath: nil,
                    date: "19 Nov",
                    time: "7:00 PM",
                    seats: ["A1", "A2"],
                    totalAmount: 330
                )
            )
        }
    }
}
