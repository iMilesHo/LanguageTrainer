/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

@main
struct EnglishPracticeApp: App {
    @StateObject private var store = EnglishTopicStore()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            SpeakingTestMainView(englishPracticeTopics: $store.topics){
                Task {
                    do {
                        try await store.save(topics: store.topics)
                    } catch {
                        errorWrapper = ErrorWrapper(error: error,
                                                    guidance: "Try again later.")
                    }
                }
            }
            .task {
                do {
                    try await store.save(topics: store.topics)
                    try await store.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error,
                                                guidance: "Scrumdinger will load sample data and continue.")
                }
            }
            .sheet(item: $errorWrapper) {
                store.topics = EnglishPracticeTopic.sampleData
            } content: { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
        }
    }
}
