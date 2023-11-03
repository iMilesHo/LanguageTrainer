/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI



struct TopicsView: View {
    @Binding var topics: [EnglishPracticeTopic]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewTopicView = false
    let saveAction: ()->Void

    var body: some View {
        NavigationStack {
            List($topics) { $topic in
                NavigationLink(destination: DetailView(topic: $topic)) {
                    CardView(topic: topic)
                }
                .listRowBackground(topic.theme.mainColor)
            }
            .navigationTitle("Daily topics")
            .toolbar {
                Button(action: {
                    isPresentingNewTopicView = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Topic")
            }
        }
        .sheet(isPresented: $isPresentingNewTopicView) {
            NewTopicSheet(topics: $topics, isPresentingNewScrumView: $isPresentingNewTopicView)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}


struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        TopicsView(topics: .constant(EnglishPracticeTopic.sampleData), saveAction: {})
    }
}
