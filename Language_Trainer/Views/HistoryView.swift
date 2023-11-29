/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct RecordingHistoryView: View {
    let history: RecordingHistory
    let topic: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("Date")
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
        .navigationTitle(Text(topic))
        .padding()
    }
}

struct RecordingHistoryView_Previews: PreviewProvider {
    static var history: RecordingHistory {
        let sample = """
                    The Great Wall of China Amalio engineeringstretching over 30 miles is a series offortifications made of stone breaktemperatures oh and all the materials it was constructed over several centuries beginning as a early as the seventh century BC with the most renewing fortunes beauty during the Ming Dynasty 1368 to 7 1644 a D initially directed by marriage days to protect against northern emotions so old was later unified and expanded it to the final Chinese empire against nomadic Travis is
                    """
        return RecordingHistory(transcript: sample)
    }
    
    static var previews: some View {
        RecordingHistoryView(history: history, topic: "The Great Wall of China")
    }
}
