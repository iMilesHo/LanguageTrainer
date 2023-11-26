/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct DetailView: View {
    @Binding var topic: EnglishPracticeTopic
    @State private var editingTopic = EnglishPracticeTopic.emptyTopic
    @State private var isPresentingEditView = false
    
    var body: some View {
        List {
            Section(header: Text("Topic Info")) {
                HStack {
                    Label("Topic Name", systemImage: "quote.bubble")
                    Spacer()
                    Text("\(topic.topic)")
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(topic.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(topic.theme.name)
                        .padding(4)
                        .foregroundColor(topic.theme.accentColor)
                        .background(topic.theme.mainColor)
                        .cornerRadius(4)
                }
                .accessibilityElement(children: .combine)
            }
            Section(header: Text("Topic Content")) {
                TextEditor(text: $topic.topicContent)
                    .frame(height: 200)
                    .padding(.vertical, 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(topic.theme.mainColor, lineWidth: 1)
                    )
//                    .disabled(true)
            }
            Section(header: Text("History")) {
                if topic.recordeHistory.isEmpty {
                    Label("No meetings yet", systemImage: "calendar.badge.exclamationmark")
                }
                ForEach(topic.recordeHistory) { history in
                    NavigationLink(destination: RecordingHistoryView(history: history, topic: topic.topic)) {
                        HStack {
                            Image(systemName: "calendar")
                            Text(history.date, style: .date)
                        }
                    }
                }
            }
        }
        .navigationTitle(topic.topic)
        .toolbar {
            Button("Edit") {
                isPresentingEditView = true
                editingTopic = topic
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationStack {
                DetailEditView(topic: $editingTopic)
                    .navigationTitle(topic.topic)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                topic = editingTopic
                            }
                        }
                    }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(topic: .constant(EnglishPracticeTopic.sampleData[0]))
        }
    }
}
