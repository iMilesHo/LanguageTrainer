/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct CardView: View {
    let topic: EnglishPracticeTopic
    var body: some View {
        VStack(alignment: .leading) {
            Text(topic.topic)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            HStack {
                Spacer()
                Label("\(topic.lengthInMinutes)", systemImage: "clock")
                    .accessibilityLabel("\(topic.lengthInMinutes) minute meeting")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(topic.theme.accentColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var topic = EnglishPracticeTopic.sampleData[0]
    static var previews: some View {
        CardView(topic: topic)
            .background(topic.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
