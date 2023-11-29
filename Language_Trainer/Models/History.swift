/*
 See LICENSE folder for this sample’s licensing information.
 */

import Foundation

struct RecordingHistory: Identifiable, Codable {
    let id: UUID
    let date: Date
    var transcript: String?
    var audioFilePathURL:URL?
    var feedback: [FeedbackItem]?
    
    init(id: UUID = UUID(), date: Date = Date(), transcript: String? = nil, audioFilePathURL: URL? = nil, feedback:[FeedbackItem]? = nil) {
        self.id = id
        self.date = date
        self.transcript = transcript
        self.audioFilePathURL = audioFilePathURL
        self.feedback = feedback
    }
}
