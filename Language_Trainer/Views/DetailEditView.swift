/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct DetailEditView: View {
    @Binding var topic: EnglishPracticeTopic
    @State private var newAttendeeName = ""
    @State private var canEdit = true
    
    var body: some View {
        VStack{
            Form {
                Section(header: Text("Topic Info")) {
                    TextField("Topic", text: $topic.topic)
                        .disabled(!canEdit)
                    HStack {
                        Slider(value: $topic.lengthInMinutesAsDouble, in: 0...30, step: 1) {
                            Text("Length")
                        }
                        .disabled(!canEdit)
                        .accessibilityValue("\(topic.lengthInMinutes) minutes")
                        Spacer()
                        Text("\(topic.lengthInMinutes) minutes")
                            .accessibilityHidden(true)
                    }
                    ThemePicker(selection: $topic.theme)
                        .disabled(!canEdit)
                }
                Section(header: Text("Topic Content")) {
                    TextEditor(text: $topic.topicContent)
                        .frame(height: 400)
                        .padding(.vertical, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(topic.theme.mainColor, lineWidth: 1)
                        )
                        .disabled(!canEdit)
                }
            }
            
            Spacer()
        }
        
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(topic: .constant(EnglishPracticeTopic.sampleData[0]))
    }
}
