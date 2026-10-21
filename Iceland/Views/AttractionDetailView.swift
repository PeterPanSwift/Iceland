import MapKit
import SwiftUI

struct AttractionDetailView: View {
    let attraction: Attraction
    @Environment(FavoritesStore.self) private var favorites

    private let headerHeight: CGFloat = 440

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                VStack(alignment: .leading, spacing: 24) {
                    infoChips

                    Text(attraction.description)
                        .font(.body)
                        .lineSpacing(6)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("必看亮點")
                            .font(.title3.bold())
                        ForEach(attraction.highlights, id: \.self) { highlight in
                            Label(highlight, systemImage: "checkmark.seal.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(attraction.category.color)
                                .font(.body.weight(.medium))
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("位置")
                            .font(.title3.bold())
                        Map(initialPosition: .camera(MapCamera(centerCoordinate: attraction.coordinate, distance: 60_000)),
                            interactionModes: []) {
                            Marker(attraction.name, systemImage: attraction.category.symbol, coordinate: attraction.coordinate)
                                .tint(attraction.category.color)
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    }

                    if let credit = PhotoStore.credit(for: attraction.id) {
                        Text("照片：\(credit.artist) · \(credit.license) · Wikimedia Commons")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 40)
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                        favorites.toggle(attraction)
                    }
                } label: {
                    Image(systemName: favorites.contains(attraction) ? "heart.fill" : "heart")
                        .foregroundStyle(favorites.contains(attraction) ? .pink : .primary)
                        .contentTransition(.symbolEffect(.replace))
                }
                .accessibilityIdentifier("favoriteButton")
                .accessibilityLabel(favorites.contains(attraction) ? "取消收藏" : "加入收藏")
            }
        }
    }

    /// Stretches when the scroll view is pulled down past the top.
    private var header: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView).minY
            PhotoView(id: attraction.id, symbol: attraction.category.symbol)
                .frame(width: proxy.size.width, height: headerHeight + max(minY, 0))
                .overlay {
                    LinearGradient(colors: [.black.opacity(0.3), .clear, .black.opacity(0.75)], startPoint: .top, endPoint: .bottom)
                }
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(attraction.englishName.uppercased())
                            .font(.caption.weight(.semibold))
                            .tracking(3)
                            .foregroundStyle(.white.opacity(0.85))
                        Text(attraction.name)
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                        Text(attraction.tagline)
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .foregroundStyle(.white)
                    .padding(22)
                }
                .offset(y: -max(minY, 0))
        }
        .frame(height: headerHeight)
    }

    private var infoChips: some View {
        HStack(spacing: 10) {
            InfoChip(title: "地區", value: attraction.region.rawValue, symbol: "mappin.and.ellipse")
            InfoChip(title: "類型", value: attraction.category.rawValue, symbol: attraction.category.symbol)
            InfoChip(title: "最佳季節", value: attraction.bestSeason, symbol: "calendar")
        }
    }
}

private struct InfoChip: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.tint)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.weight(.semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, minHeight: 92)
        .padding(.horizontal, 6)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
