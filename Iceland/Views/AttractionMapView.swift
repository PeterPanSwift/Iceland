import MapKit
import SwiftUI

struct AttractionMapView: View {
    private static let overview = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 64.85, longitude: -18.8),
                           span: MKCoordinateSpan(latitudeDelta: 4.8, longitudeDelta: 11.5))
    )

    @State private var position = AttractionMapView.overview
    @State private var selectedID: String?

    private var selected: Attraction? {
        IcelandData.attractions.first { $0.id == selectedID }
    }

    var body: some View {
        NavigationStack {
            Map(position: $position, selection: $selectedID) {
                ForEach(IcelandData.attractions) { attraction in
                    Marker(attraction.name, systemImage: attraction.category.symbol, coordinate: attraction.coordinate)
                        .tint(attraction.category.color)
                        .tag(attraction.id)
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    if let selected {
                        NavigationLink(value: selected) {
                            MapCard(attraction: selected)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("mapCard")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    chips
                }
                .padding(.bottom, 8)
            }
            .navigationTitle("景點地圖")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("全覽", systemImage: "globe.europe.africa") {
                        withAnimation(.easeInOut(duration: 1.2)) {
                            selectedID = nil
                            position = Self.overview
                        }
                    }
                    .accessibilityIdentifier("overviewButton")
                }
            }
            .onChange(of: selectedID) { _, id in
                guard let attraction = IcelandData.attractions.first(where: { $0.id == id }) else { return }
                withAnimation(.easeInOut(duration: 1.4)) {
                    position = .camera(MapCamera(centerCoordinate: attraction.coordinate, distance: 40_000, heading: 0, pitch: 55))
                }
            }
            .navigationDestination(for: Attraction.self) { attraction in
                AttractionDetailView(attraction: attraction)
            }
        }
    }

    private var chips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(IcelandData.attractions) { attraction in
                    let isSelected = attraction.id == selectedID
                    Button {
                        withAnimation(.snappy) { selectedID = attraction.id }
                    } label: {
                        Label(attraction.name, systemImage: attraction.category.symbol)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .foregroundStyle(isSelected ? .white : .primary)
                            .background {
                                if isSelected {
                                    Capsule().fill(attraction.category.color)
                                } else {
                                    Capsule().fill(.regularMaterial)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("chip-\(attraction.id)")
                }
            }
            .padding(.horizontal)
        }
        .accessibilityIdentifier("chipRow")
    }
}

private struct MapCard: View {
    let attraction: Attraction

    var body: some View {
        HStack(spacing: 14) {
            PhotoView(id: attraction.id, symbol: attraction.category.symbol)
                .frame(width: 110, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            VStack(alignment: .leading, spacing: 6) {
                Text(attraction.name)
                    .font(.headline)
                Text(attraction.englishName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(attraction.tagline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Label("查看介紹", systemImage: "arrow.right.circle.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tint)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
    }
}
