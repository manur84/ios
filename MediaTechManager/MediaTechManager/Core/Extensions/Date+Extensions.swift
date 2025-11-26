//
//  Date+Extensions.swift
//  MediaTechManager
//
//  Date Extensions
//

import Foundation

extension Date {

    // MARK: - Formatierung

    /// Formatiert das Datum im deutschen Standard-Format (z.B. "24.12.2024")
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormats.standard
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: self)
    }

    /// Formatiert das Datum kurz (z.B. "24.12.")
    var formattedShort: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormats.short
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: self)
    }

    /// Formatiert mit Zeit (z.B. "24.12.2024, 14:30")
    var formattedWithTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormats.withTime
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: self)
    }

    /// Nur Zeit (z.B. "14:30")
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormats.timeOnly
        formatter.locale = Locale(identifier: "de_DE")
        return formatter.string(from: self)
    }

    /// Relativer String (z.B. "Heute", "Gestern", "In 3 Tagen")
    var relativeFormatted: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// Für Dateinamen geeignet (z.B. "2024-12-24_143000")
    var filenameFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormats.filename
        return formatter.string(from: self)
    }

    // MARK: - Berechnungen

    /// Ist heute
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Ist morgen
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }

    /// Ist gestern
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// Ist in der Vergangenheit
    var isPast: Bool {
        self < Date()
    }

    /// Ist in der Zukunft
    var isFuture: Bool {
        self > Date()
    }

    /// Ist in dieser Woche
    var isThisWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// Ist in diesem Monat
    var isThisMonth: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    /// Ist in diesem Jahr
    var isThisYear: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }

    /// Start des Tages
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// Ende des Tages
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }

    /// Start der Woche
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }

    /// Start des Monats
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }

    /// Tage hinzufügen
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    /// Wochen hinzufügen
    func addingWeeks(_ weeks: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self) ?? self
    }

    /// Monate hinzufügen
    func addingMonths(_ months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }

    /// Tage zwischen zwei Daten
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay)
        return components.day ?? 0
    }

    // MARK: - Static

    /// Erstellt ein Datum aus Komponenten
    static func from(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components)
    }
}
