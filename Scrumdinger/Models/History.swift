/*
 See LICENSE folder for this sample’s licensing information.
 */

import Foundation

struct RecordingHistory: Identifiable, Codable {
    let id: UUID
    let date: Date
    var transcript: String?
    var audioFilePathURL:URL?
    
    init(id: UUID = UUID(), date: Date = Date(), transcript: String? = nil, audioFilePathURL: URL? = nil) {
        self.id = id
        self.date = date
        self.transcript = transcript
        self.audioFilePathURL = audioFilePathURL
    }
}


struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    var attendees: [DailyScrum.Attendee]
    var transcript: String?
    
    init(id: UUID = UUID(), date: Date = Date(), attendees: [DailyScrum.Attendee], transcript: String? = nil) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.transcript = transcript
    }
}
