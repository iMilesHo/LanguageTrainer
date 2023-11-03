/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct RecordingHistoryView: View {
    let history: RecordingHistory

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("Topics")
                    .font(.headline)
                Text(history.date.description)
                if let transcript = history.transcript {
                    Text("Transcript")
                        .font(.headline)
                        .padding(.top)
                    Text(transcript)
                }
            }
        }
        .navigationTitle(Text(history.date, style: .date))
        .padding()
    }
}

struct RecordingHistoryView_Previews: PreviewProvider {
    static var history: RecordingHistory {
        RecordingHistory(transcript: "abc abd abdb fakuhf adbkj fhakuhf fakhjfh")
    }
    
    static var previews: some View {
        RecordingHistoryView(history: history)
    }
}
