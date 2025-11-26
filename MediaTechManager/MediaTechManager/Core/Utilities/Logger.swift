//
//  Logger.swift
//  MediaTechManager
//
//  Logging Utility (ersetzt print() statements)
//

import Foundation
import os.log

/// Zentralisiertes Logging für die App
enum Logger {

    // MARK: - Log Categories

    private static let subsystem = Constants.App.bundleIdentifier

    private static let general = OSLog(subsystem: subsystem, category: "general")
    private static let data = OSLog(subsystem: subsystem, category: "data")
    private static let network = OSLog(subsystem: subsystem, category: "network")
    private static let ui = OSLog(subsystem: subsystem, category: "ui")
    private static let auth = OSLog(subsystem: subsystem, category: "auth")
    private static let sync = OSLog(subsystem: subsystem, category: "sync")

    // MARK: - Log Levels

    enum Level {
        case debug
        case info
        case warning
        case error
        case fault

        var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            case .fault: return .fault
            }
        }

        var emoji: String {
            switch self {
            case .debug: return "🔍"
            case .info: return "ℹ️"
            case .warning: return "⚠️"
            case .error: return "❌"
            case .fault: return "💥"
            }
        }
    }

    // MARK: - Log Categories

    enum Category {
        case general
        case data
        case network
        case ui
        case auth
        case sync

        var log: OSLog {
            switch self {
            case .general: return Logger.general
            case .data: return Logger.data
            case .network: return Logger.network
            case .ui: return Logger.ui
            case .auth: return Logger.auth
            case .sync: return Logger.sync
            }
        }
    }

    // MARK: - Logging Methods

    /// Hauptmethode für Logging
    static func log(
        _ message: String,
        level: Level = .info,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let filename = (file as NSString).lastPathComponent
        let logMessage = "\(level.emoji) [\(filename):\(line)] \(function) - \(message)"
        os_log("%{public}@", log: category.log, type: level.osLogType, logMessage)
        #else
        // In Release nur Warnings und höher
        if level != .debug && level != .info {
            os_log("%{public}@", log: category.log, type: level.osLogType, message)
        }
        #endif
    }

    // MARK: - Convenience Methods

    /// Debug Log
    static func debug(
        _ message: String,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }

    /// Info Log
    static func info(
        _ message: String,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }

    /// Warning Log
    static func warning(
        _ message: String,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }

    /// Error Log
    static func error(
        _ message: String,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .error, category: category, file: file, function: function, line: line)
    }

    /// Error Log mit Error Object
    static func error(
        _ error: Error,
        message: String? = nil,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let errorMessage = message ?? "Error occurred"
        log("\(errorMessage): \(error.localizedDescription)", level: .error, category: category, file: file, function: function, line: line)
    }

    /// Fault Log (kritische Fehler)
    static func fault(
        _ message: String,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .fault, category: category, file: file, function: function, line: line)
    }

    // MARK: - Category-specific Convenience

    /// Data Operation Log
    static func data(_ message: String, level: Level = .info) {
        log(message, level: level, category: .data)
    }

    /// Network Log
    static func network(_ message: String, level: Level = .info) {
        log(message, level: level, category: .network)
    }

    /// UI Log
    static func ui(_ message: String, level: Level = .info) {
        log(message, level: level, category: .ui)
    }

    /// Auth Log
    static func auth(_ message: String, level: Level = .info) {
        log(message, level: level, category: .auth)
    }

    /// Sync Log
    static func sync(_ message: String, level: Level = .info) {
        log(message, level: level, category: .sync)
    }
}
