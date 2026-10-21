import SwiftUI

struct ExploreView: View {
    @Environment(FavoritesStore.self) private var favorites

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    HeroHeader()

                    SectionTitle(title: "精選景點", subtitle: "Featured")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(IcelandData.featured) { attraction in
                                NavigationLink(value: attraction) {
                                    FeaturedCard(attraction: attraction)
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("featured-\(attraction.id)")
                            }
                        }
                        .padding(.horizontal)
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .accessibilityIdentifier("featuredCarousel")

                    ForEach(Region.allCases) { region in
                        VStack(alignment: .leading, spacing: 12) {
                            SectionTitle(title: region.rawValue, subtitle: "\(IcelandData.attractions(in: region).count) 個景點")
                            ForEach(IcelandData.attractions(in: region)) { attraction in
                                NavigationLink(value: attraction) {
                                    AttractionRow(attraction: attraction, isFavorite: favorites.contains(attraction))
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("row-\(attraction.id)")
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom, 32)
            }
            .ignoresSafeArea(edges: .top)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Attraction.self) { attraction in
                AttractionDetailView(attraction: attraction)
            }
        }
    }
}

private struct HeroHeader: View {
    var body: some View {
        PhotoView(id: "aurora", symbol: "sparkles")
            .frame(height: 460)
            .overlay {
                LinearGradient(colors: [.black.opacity(0.35), .clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("ÍSLAND")
                        .font(.caption.weight(.semibold))
                        .tracking(6)
                        .foregroundStyle(.white.opacity(0.8))
                    Text("冰島")
                        .font(.system(size: 54, weight: .heavy, design: .rounded))
                    Text("火與冰之國 · 冰河、火山、瀑布與極光")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .foregroundStyle(.white)
                .padding(24)
            }
            .accessibilityIdentifier("hero")
    }
}

struct SectionTitle: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.title2.bold())
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal)
    }
}

private struct FeaturedCard: View {
    let attraction: Attraction

    var body: some View {
        PhotoView(id: attraction.id, symbol: attraction.category.symbol)
            .frame(width: 280, height: 360)
            .overlay {
                LinearGradient(colors: [.clear, .clear, .black.opacity(0.75)], startPoint: .top, endPoint: .bottom)
            }
            .overlay(alignment: .topLeading) {
                CategoryBadge(category: attraction.category)
                    .padding(14)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(attraction.name)
                        .font(.title2.bold())
                    Text(attraction.tagline)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                }
                .foregroundStyle(.white)
                .padding(18)
            }
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .shadow(color: .black.opacity(0.18), radius: 12, y: 8)
    }
}

struct AttractionRow: View {
    let attraction: Attraction
    var isFavorite = false

    var body: some View {
        HStack(spacing: 14) {
            PhotoView(id: attraction.id, symbol: attraction.category.symbol)
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(attraction.name)
                        .font(.headline)
                    if isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundStyle(.pink)
                    }
                }
                Text(attraction.englishName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(attraction.tagline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                CategoryBadge(category: attraction.category, compact: true)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding(10)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .contentShape(Rectangle())
    }
}

struct CategoryBadge: View {
    let category: Category
    var compact = false

    var body: some View {
        Label(category.rawValue, systemImage: category.symbol)
            .font(compact ? .caption2.weight(.semibold) : .caption.weight(.semibold))
            .padding(.horizontal, compact ? 8 : 10)
            .padding(.vertical, compact ? 4 : 6)
            .foregroundStyle(compact ? category.color : .white)
            .background {
                if compact {
                    Capsule().fill(category.color.opacity(0.15))
                } else {
                    Capsule().fill(.ultraThinMaterial)
                }
            }
    }
}
