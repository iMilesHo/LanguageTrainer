import SwiftUI

struct FeedbackItem: Codable {
    let original: String
    let recognized: String
    let score: Double
}

struct PronunciationFeedbackView: View {
    var feedback: [FeedbackItem]
    @Binding var isPresentingView: Bool
    var overallScore: Double {
        var overAllScore = 0.0
        for i in feedback {
            overAllScore += i.score
        }
        return overAllScore/Double(feedback.count)
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Overall Score").font(.headline)) {
                    ScoreView(score: Int(overallScore*100))
                }
                
                Section(header: Text("Detailed Feedback").font(.headline)) {
                    ForEach(feedback, id: \.original) { item in
                        FeedbackCard(item: item)
                    }
                }
            }
            .navigationTitle("Pronunciation Feedback")
            .navigationBarItems(trailing: Button("Done") {
                isPresentingView.toggle()
            })
        }
    }
}

struct FeedbackCard: View {
    var item: FeedbackItem

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Original:").fontWeight(.semibold)
            Text(item.original).font(.subheadline)
            Text("Recognized:").fontWeight(.semibold)
            Text(item.recognized).font(.subheadline)
            ScoreView(score: Int(item.score * 100))
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct ScoreView: View {
    let score: Int

    var body: some View {
        HStack {
            Text("Score: \(score)/100").fontWeight(.bold)
            Spacer()
            ProgressView(value: Double(score), total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: colorForScore(Int(score))))
                .frame(width: 100)
        }
    }

    private func colorForScore(_ score: Int) -> Color {
        switch score {
        case 0..<50:
            return .red
        case 50..<75:
            return .orange
        case 75...100:
            return .green
        default:
            return .gray
        }
    }
}

struct PronunciationFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        PronunciationFeedbackView(
            feedback: [
                FeedbackItem(
                    original: "The Great Wall of China, a marvel of engineering stretching over 13,000 miles, is a series of fortifications made of stone, brick, tamped earth, wood, and other materials.",
                    recognized: "The Great Wall of China, a movie of engineering striking over 13,000 miles, is a series of fortifications made of stone, brick, tamped earth, wood, and other materials.",
                    score: 0.8680930137634277
                ),
                FeedbackItem(
                    original: "The Great Wall of China, a marvel of engineering stretching over 13,000 miles, is a series of fortifications made of stone, brick, tamped earth, wood, and other materials.",
                    recognized: "The Great Wall of China, a movie of engineering striking over 13,000 miles, is a series of fortifications made of stone, brick, tamped earth, wood, and other materials.",
                    score: 0.680930137634277
                )
                
            ],
            isPresentingView: .constant(true)
        )
    }
}


import Foundation

struct PronunciationFeedbackManager {
    let baseURL = URL(string: "http://3.135.249.33:5001/predict")!

    func postFeedback(original: String, recognized: String, completion: @escaping (Result<[FeedbackItem], Error>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "original_sentences": original,
            "recognized_sentences": recognized
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data was nil"])))
                return
            }

            do {
                let feedbackItems = try JSONDecoder().decode([FeedbackItem].self, from: data)
                completion(.success(feedbackItems))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
