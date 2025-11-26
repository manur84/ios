//
//  StatCard.swift
//  MediaTechManager
//
//  Statistik-Karte für Dashboard
//

import SwiftUI

struct StatCard: View {

    // MARK: - Properties

    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: Trend?

    // MARK: - Types

    enum Trend {
        case up(String)
        case down(String)
        case neutral

        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "minus"
            }
        }

        var color: Color {
            switch self {
            case .up: return Color(hex: "34C759")
            case .down: return Color(hex: "FF3B30")
            case .neutral: return .gray
            }
        }
    }

    // MARK: - Initializer

    init(
        title: String,
        value: String,
        icon: String,
        color: Color = Color(hex: "007AFF"),
        trend: Trend? = nil
    ) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
        self.trend = trend
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Header
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)

                Spacer()

                if let trend {
                    trendBadge(trend)
                }
            }

            // Value
            Text(value)
                .font(.displayMedium)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            // Title
            Text(title)
                .font(.bodySmall)
                .foregroundStyle(.secondary)
        }
        .padding(Spacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadiusLarge))
    }

    // MARK: - Trend Badge

    @ViewBuilder
    private func trendBadge(_ trend: Trend) -> some View {
        switch trend {
        case .up(let value), .down(let value):
            HStack(spacing: 2) {
                Image(systemName: trend.icon)
                Text(value)
            }
            .font(.labelSmall)
            .foregroundStyle(trend.color)

        case .neutral:
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
        StatCard(
            title: "Geräte gesamt",
            value: "127",
            icon: "shippingbox.fill",
            color: Color(hex: "007AFF")
        )

        StatCard(
            title: "Verfügbar",
            value: "98",
            icon: "checkmark.circle.fill",
            color: Color(hex: "34C759"),
            trend: .up("+5")
        )

        StatCard(
            title: "Ausgeliehen",
            value: "29",
            icon: "arrow.right.circle.fill",
            color: Color(hex: "FF9500")
        )

        StatCard(
            title: "Überfällig",
            value: "3",
            icon: "exclamationmark.triangle.fill",
            color: Color(hex: "FF3B30"),
            trend: .down("-2")
        )
    }
    .padding()
}
