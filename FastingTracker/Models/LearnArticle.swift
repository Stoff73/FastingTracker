import Foundation

struct LearnArticle: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let emoji: String
    let category: Category
    let content: [ContentBlock]

    enum Category: String, CaseIterable {
        case beginner = "Getting Started"
        case science = "The Science"
        case tips = "Tips & Tricks"
        case safety = "Safety"
    }

    struct ContentBlock: Identifiable {
        let id = UUID()
        let heading: String?
        let body: String
    }

    static let articles: [LearnArticle] = [
        LearnArticle(
            title: "What is Intermittent Fasting?",
            subtitle: "A beginner's guide to fasting",
            emoji: "📖",
            category: .beginner,
            content: [
                ContentBlock(heading: nil, body: "Intermittent fasting (IF) is an eating pattern that cycles between periods of fasting and eating. It doesn't specify which foods to eat, but rather when you should eat them."),
                ContentBlock(heading: "Common Methods", body: "The 16:8 method involves fasting for 16 hours and eating within an 8-hour window. The 20:4 method extends the fast to 20 hours with a 4-hour eating window. Extended fasts of 24-72 hours are practiced by experienced fasters."),
                ContentBlock(heading: "How It Works", body: "When you fast, several things happen in your body on a cellular and molecular level. Your body adjusts hormone levels to make stored body fat more accessible, and cells initiate important repair processes.")
            ]
        ),
        LearnArticle(
            title: "The 5 Stages of Fasting",
            subtitle: "What happens to your body over time",
            emoji: "🔬",
            category: .science,
            content: [
                ContentBlock(heading: "Stage 1: Digestion (0-12h)", body: "Your body is processing your last meal. Blood sugar rises as carbohydrates are broken down into glucose. Insulin is released to shuttle glucose into cells for energy. Excess glucose is stored as glycogen in the liver and muscles."),
                ContentBlock(heading: "Stage 2: Fat Burning (12-18h)", body: "Glycogen stores begin to deplete and your body starts mobilizing fat stores for energy. Insulin drops to baseline levels, allowing hormone-sensitive lipase to break down stored triglycerides into free fatty acids."),
                ContentBlock(heading: "Stage 3: Ketosis (18-24h)", body: "Your liver converts fatty acids into ketone bodies — beta-hydroxybutyrate, acetoacetate, and acetone. These ketones serve as an efficient alternative fuel source for your brain, which normally relies on glucose."),
                ContentBlock(heading: "Stage 4: Autophagy (24-48h)", body: "Your cells activate autophagy, a process where damaged proteins, organelles, and cellular debris are tagged for recycling. This cellular housekeeping is associated with longevity and disease prevention."),
                ContentBlock(heading: "Stage 5: Deep Cleanse (48h+)", body: "Growth hormone levels may increase significantly. The immune system begins regenerating, replacing old white blood cells with new ones. Stem cell-based regeneration may be triggered.")
            ]
        ),
        LearnArticle(
            title: "Benefits of Fasting",
            subtitle: "Why people fast and the research behind it",
            emoji: "✨",
            category: .science,
            content: [
                ContentBlock(heading: "Weight Management", body: "Fasting can help reduce calorie intake and boost metabolism through increased norepinephrine levels. Studies show intermittent fasting can lead to 3-8% weight loss over 3-24 weeks."),
                ContentBlock(heading: "Insulin Sensitivity", body: "Fasting periods allow insulin levels to drop, improving insulin sensitivity. This can help reduce the risk of type 2 diabetes and metabolic syndrome."),
                ContentBlock(heading: "Brain Health", body: "Fasting increases production of brain-derived neurotrophic factor (BDNF), which supports the growth of new neurons. Many fasters report improved mental clarity and focus during fasting periods."),
                ContentBlock(heading: "Cellular Repair", body: "Autophagy triggered during fasting helps remove damaged cellular components. This process may protect against several diseases including cancer and Alzheimer's disease.")
            ]
        ),
        LearnArticle(
            title: "Tips for Your First Fast",
            subtitle: "Make your fasting journey easier",
            emoji: "💡",
            category: .tips,
            content: [
                ContentBlock(heading: "Start Slow", body: "Begin with a 12-hour fast (e.g., 8 PM to 8 AM) and gradually extend. Most of this time you'll be sleeping, making it an easy introduction."),
                ContentBlock(heading: "Stay Hydrated", body: "Drink plenty of water, herbal tea, and black coffee during fasting periods. Proper hydration helps reduce hunger and supports your body's detoxification processes."),
                ContentBlock(heading: "Keep Busy", body: "Hunger often comes in waves and passes. Staying occupied with work, exercise, or hobbies helps the time pass and keeps your mind off eating."),
                ContentBlock(heading: "Break Your Fast Gently", body: "Start with a small, easily digestible meal. Avoid breaking a long fast with a large, heavy meal as this can cause digestive discomfort."),
                ContentBlock(heading: "Listen to Your Body", body: "If you feel dizzy, nauseous, or unwell, it's okay to break your fast early. Fasting should feel challenging but not dangerous.")
            ]
        ),
        LearnArticle(
            title: "When Not to Fast",
            subtitle: "Important safety considerations",
            emoji: "⚠️",
            category: .safety,
            content: [
                ContentBlock(heading: "Who Should Avoid Fasting", body: "Pregnant or breastfeeding women, children and teenagers, people with a history of eating disorders, those with type 1 diabetes, and anyone underweight should not fast without medical supervision."),
                ContentBlock(heading: "Medications", body: "If you take medications that require food, consult your doctor before starting a fasting regimen. Some medications need to be taken with meals for proper absorption and safety."),
                ContentBlock(heading: "Warning Signs", body: "Stop fasting immediately if you experience: persistent dizziness, fainting, rapid heartbeat, severe headaches, confusion, or extreme weakness. These may indicate your body is not tolerating the fast well."),
                ContentBlock(heading: "Consult Your Doctor", body: "Always consult with a healthcare professional before starting any fasting program, especially if you have pre-existing health conditions or take regular medications.")
            ]
        ),
        LearnArticle(
            title: "Electrolytes and Fasting",
            subtitle: "Keeping your minerals balanced",
            emoji: "🧂",
            category: .tips,
            content: [
                ContentBlock(heading: "Why Electrolytes Matter", body: "During fasting, your kidneys excrete more sodium and water. This can lead to imbalances in key electrolytes: sodium, potassium, and magnesium. Symptoms include headaches, fatigue, and muscle cramps."),
                ContentBlock(heading: "Sodium", body: "A pinch of sea salt in water can help maintain sodium levels. This is especially important during longer fasts (24+ hours)."),
                ContentBlock(heading: "Magnesium", body: "Magnesium supports hundreds of enzymatic reactions. Consider magnesium supplements during extended fasts to prevent cramps and support sleep quality."),
                ContentBlock(heading: "What Won't Break Your Fast", body: "Plain water, black coffee, unsweetened tea, and small amounts of salt or mineral supplements generally won't break your fast or interrupt autophagy.")
            ]
        )
    ]
}
