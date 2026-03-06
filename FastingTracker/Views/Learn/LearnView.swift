import SwiftUI

struct LearnView: View {
    @State private var selectedCategory: LearnArticle.Category? = nil

    private var filteredArticles: [LearnArticle] {
        if let category = selectedCategory {
            return LearnArticle.articles.filter { $0.category == category }
        }
        return LearnArticle.articles
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    categoryFilter

                    // Featured stage breakdown
                    if selectedCategory == nil {
                        fastingStagesCard
                    }

                    LazyVStack(spacing: 12) {
                        ForEach(filteredArticles) { article in
                            NavigationLink {
                                ArticleDetailView(article: article)
                            } label: {
                                ArticleCard(article: article)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .navigationTitle("Learn")
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(LearnArticle.Category.allCases, id: \.self) { category in
                    FilterChip(title: category.rawValue, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
        }
    }

    private var fastingStagesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Fasting Stages")
                .font(.headline)

            ForEach(FastingStage.stages) { stage in
                HStack(spacing: 12) {
                    Text(stage.emoji)
                        .font(.title2)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(stage.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(Int(stage.hours))h+")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(stage.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if stage.hours != FastingStage.stages.last?.hours {
                    Divider()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? .cyan : Color.gray.opacity(0.15))
                )
        }
    }
}

// MARK: - Article Card

struct ArticleCard: View {
    let article: LearnArticle

    var body: some View {
        HStack(spacing: 14) {
            Text(article.emoji)
                .font(.system(size: 36))
                .frame(width: 56, height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.15))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(article.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(article.category.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.cyan)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
    }
}

// MARK: - Article Detail

struct ArticleDetailView: View {
    let article: LearnArticle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text(article.emoji)
                        .font(.system(size: 56))

                    Text(article.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(article.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)

                // Content blocks
                ForEach(article.content) { block in
                    VStack(alignment: .leading, spacing: 8) {
                        if let heading = block.heading {
                            Text(heading)
                                .font(.headline)
                        }
                        Text(block.body)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                    }
                }
            }
            .padding()
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
        .inlineNavigationBar()
    }
}
