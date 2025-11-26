//
//  AuditLog.swift
//  MediaTechManager
//
//  SwiftData Model - Audit-Log / Aktivitätsprotokoll
//

import Foundation
import SwiftData

@Model
final class AuditLog {

    // MARK: - Properties

    /// Eindeutige ID
    var id: UUID

    /// Zeitstempel
    var timestamp: Date

    /// Art der Aktion
    var actionTypeRawValue: String

    var actionType: AuditActionType {
        get { AuditActionType(rawValue: actionTypeRawValue) ?? .other }
        set { actionTypeRawValue = newValue.rawValue }
    }

    /// Betroffene Entity (z.B. "Equipment", "Rental")
    var entityType: String

    /// ID der betroffenen Entity
    var entityId: UUID?

    /// Name/Beschreibung der Entity
    var entityName: String

    /// Beschreibung der Änderung
    var descriptionText: String

    /// Alte Werte (JSON)
    var oldValues: String?

    /// Neue Werte (JSON)
    var newValues: String?

    /// Benutzer/Gerät Info
    var userInfo: String

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        actionType: AuditActionType = .other,
        entityType: String = "",
        entityId: UUID? = nil,
        entityName: String = "",
        descriptionText: String = "",
        oldValues: String? = nil,
        newValues: String? = nil,
        userInfo: String = ""
    ) {
        self.id = id
        self.timestamp = timestamp
        self.actionTypeRawValue = actionType.rawValue
        self.entityType = entityType
        self.entityId = entityId
        self.entityName = entityName
        self.descriptionText = descriptionText
        self.oldValues = oldValues
        self.newValues = newValues
        self.userInfo = userInfo
    }
}

// MARK: - Identifiable

extension AuditLog: Identifiable {}

// MARK: - AuditActionType Enum

enum AuditActionType: String, CaseIterable, Codable {

    case create = "Erstellt"
    case update = "Bearbeitet"
    case delete = "Gelöscht"
    case rentalStart = "Ausleihe gestartet"
    case rentalEnd = "Ausleihe beendet"
    case handover = "Übergabe"
    case returnItem = "Rücknahme"
    case maintenance = "Wartung"
    case damage = "Schaden"
    case statusChange = "Statusänderung"
    case export = "Export"
    case importData = "Import"
    case backup = "Backup"
    case restore = "Wiederherstellung"
    case login = "Anmeldung"
    case logout = "Abmeldung"
    case other = "Sonstiges"

    var icon: String {
        switch self {
        case .create:
            return "plus.circle.fill"
        case .update:
            return "pencil.circle.fill"
        case .delete:
            return "trash.circle.fill"
        case .rentalStart:
            return "arrow.right.circle.fill"
        case .rentalEnd:
            return "arrow.left.circle.fill"
        case .handover:
            return "hand.raised.fill"
        case .returnItem:
            return "arrow.uturn.backward.circle.fill"
        case .maintenance:
            return "wrench.fill"
        case .damage:
            return "exclamationmark.triangle.fill"
        case .statusChange:
            return "arrow.triangle.2.circlepath"
        case .export:
            return "square.and.arrow.up.fill"
        case .importData:
            return "square.and.arrow.down.fill"
        case .backup:
            return "externaldrive.fill"
        case .restore:
            return "arrow.counterclockwise.circle.fill"
        case .login:
            return "person.crop.circle.badge.checkmark"
        case .logout:
            return "person.crop.circle.badge.xmark"
        case .other:
            return "ellipsis.circle.fill"
        }
    }

    var displayName: String {
        rawValue
    }

    var color: String {
        switch self {
        case .create:
            return "34C759"
        case .update:
            return "007AFF"
        case .delete:
            return "FF3B30"
        case .rentalStart, .rentalEnd, .handover, .returnItem:
            return "5856D6"
        case .maintenance:
            return "FF9500"
        case .damage:
            return "FF3B30"
        case .statusChange:
            return "5AC8FA"
        case .export, .importData, .backup, .restore:
            return "8E8E93"
        case .login, .logout:
            return "AF52DE"
        case .other:
            return "636366"
        }
    }
}

// MARK: - Convenience Factory Methods

extension AuditLog {

    /// Erstellt einen Log-Eintrag für Equipment
    static func equipmentLog(
        actionType: AuditActionType,
        equipment: Equipment,
        description: String
    ) -> AuditLog {
        AuditLog(
            actionType: actionType,
            entityType: "Equipment",
            entityId: equipment.id,
            entityName: equipment.displayName,
            descriptionText: description
        )
    }

    /// Erstellt einen Log-Eintrag für Rental
    static func rentalLog(
        actionType: AuditActionType,
        rental: Rental,
        description: String
    ) -> AuditLog {
        AuditLog(
            actionType: actionType,
            entityType: "Rental",
            entityId: rental.id,
            entityName: rental.rentalNumber,
            descriptionText: description
        )
    }

    /// Erstellt einen Log-Eintrag für Customer
    static func customerLog(
        actionType: AuditActionType,
        customer: Customer,
        description: String
    ) -> AuditLog {
        AuditLog(
            actionType: actionType,
            entityType: "Customer",
            entityId: customer.id,
            entityName: customer.fullName,
            descriptionText: description
        )
    }
}
