//
//  BookingHidtoryView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRView: View {

    let text: String

    var body: some View {
        if let image = makeImage() {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
        }
    }

    private func makeImage() -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(text.utf8)

        guard let output = filter.outputImage else { return nil }

        let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        let context = CIContext()

        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

struct BookingHidtoryView_Previews: PreviewProvider {
    static var previews: some View {
        QRView(text: " ")
    }
}
