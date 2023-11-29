/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI


struct NewTopicSheet: View {
    @State private var newTopic = EnglishPracticeTopic.emptyTopic
    @Binding var topics: [EnglishPracticeTopic]
    @Binding var isPresentingNewScrumView: Bool
    
    var body: some View {
        NavigationStack {
            DetailEditView(topic: $newTopic)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isPresentingNewScrumView = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            topics.append(newTopic)
                            isPresentingNewScrumView = false
                        }
                    }
                }
        }
    }
}

struct TopicInfoSheet: View {
    @State private var newTopic = EnglishPracticeTopic.emptyTopic
    @Binding var topics: [EnglishPracticeTopic]
    @Binding var isPresentingNewScrumView: Bool
    
    var body: some View {
        NavigationStack {
            DetailEditView(topic: $newTopic)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isPresentingNewScrumView = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            topics.append(newTopic)
                            isPresentingNewScrumView = false
                        }
                    }
                }
        }
    }
}

struct NewScrumSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewTopicSheet(topics: .constant(EnglishPracticeTopic.sampleData), isPresentingNewScrumView: .constant(true))
    }
}
