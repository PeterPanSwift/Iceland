import SwiftUI

struct AboutIcelandView: View {
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    PhotoView(id: "reykjavik", symbol: "building.2.fill")
                        .frame(height: 380)
                        .overlay {
                            LinearGradient(colors: [.black.opacity(0.35), .clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                        }
                        .overlay(alignment: .bottomLeading) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("關於冰島")
                                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                                Text("北大西洋上的火山島，橫跨兩大板塊")
                                    .font(.headline)
                                    .foregroundStyle(.white.opacity(0.9))
                            }
                            .foregroundStyle(.white)
                            .padding(24)
                        }

                    Text("冰島位於北極圈邊緣，全國約有 11% 的面積被冰河覆蓋，同時擁有超過 30 座活火山。豐沛的地熱讓這裡幾乎所有家庭都使用地熱供暖，也孕育出無數溫泉。夏天有永晝，冬天則是追逐極光的最佳舞台。")
                        .lineSpacing(6)
                        .padding(.horizontal)

                    SectionTitle(title: "基本資料", subtitle: "Quick facts")
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(IcelandData.facts) { fact in
                            VStack(spacing: 8) {
                                Image(systemName: fact.symbol)
                                    .font(.title2)
                                    .foregroundStyle(.tint)
                                Text(fact.title)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(fact.value)
                                    .font(.footnote.weight(.semibold))
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxWidth: .infinity, minHeight: 110)
                            .background(.background.secondary, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        }
                    }
                    .padding(.horizontal)

                    SectionTitle(title: "旅遊小提醒", subtitle: "Travel tips")
                    VStack(spacing: 12) {
                        ForEach(IcelandData.tips) { tip in
                            HStack(alignment: .top, spacing: 14) {
                                Image(systemName: tip.symbol)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .frame(width: 52, height: 52)
                                    .background(.tint, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(tip.title)
                                        .font(.headline)
                                    Text(tip.detail)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(14)
                            .background(.background.secondary, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        }
                    }
                    .padding(.horizontal)

                    if !PhotoStore.credits.isEmpty {
                        SectionTitle(title: "照片來源", subtitle: "Wikimedia Commons")
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(PhotoStore.credits) { credit in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(credit.title.replacingOccurrences(of: "File:", with: ""))
                                        .font(.caption.weight(.semibold))
                                    Text("\(credit.artist) · \(credit.license)")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 32)
            }
            .ignoresSafeArea(edges: .top)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
