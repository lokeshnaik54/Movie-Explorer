//
//  Movie+release.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import Foundation

extension Movie {

    private static let releaseFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    var releaseDateValue: Date? {
        Movie.releaseFormatter.date(from: releaseDate)
    }

    /// A missing or unparsable date counts as not released yet.
    var isReleased: Bool {
        guard let date = releaseDateValue else { return false }
        return date <= Date()
    }

    var releaseDateText: String {
        guard let date = releaseDateValue else { return "Release date TBA" }
        return date.formatted(date: .long, time: .omitted)
    }
}
