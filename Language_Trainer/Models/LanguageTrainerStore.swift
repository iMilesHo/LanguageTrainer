//
//  LanguageTrainerStore.swift
//  Language_Trainer
//
//  Created by YuanlaiHe on 2023-11-29.
//


import SwiftUI


@MainActor
class EnglishTopicStore: ObservableObject {
    @Published var topics: [EnglishPracticeTopic] = EnglishPracticeTopic.sampleData
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("englishTopic.data")
    }
    
    func load() async throws {
        let task = Task<[EnglishPracticeTopic], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let topics = try JSONDecoder().decode([EnglishPracticeTopic].self, from: data)
            return topics
        }
        let topics = try await task.value
        self.topics = topics
    }
    
    func save(topics: [EnglishPracticeTopic]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(topics)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}


/// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.

@MainActor
final class EnglishSpeakingTimer: ObservableObject {
    /// The number of seconds since the beginning of the meeting.
    @Published var secondsElapsed = 0
    /// The number of seconds until all attendees have had a turn to speak.
    @Published var secondsRemaining = 0
    /// All meeting attendees, listed in the order they will speak.

    /// The scrum meeting length.
    private(set) var lengthInMinutes: Int

    private weak var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var lengthInSeconds: Int { lengthInMinutes * 60 }
    private var startDate: Date?
    
    /**
     Initialize a new timer. Initializing a time with no arguments creates a ScrumTimer with no attendees and zero length.
     Use `startScrum()` to start the timer.
     
     - Parameters:
        - lengthInMinutes: The meeting length.
        -  attendees: A list of attendees for the meeting.
     */
    init(lengthInMinutes: Int = 0) {
        self.lengthInMinutes = lengthInMinutes
        secondsRemaining = lengthInSeconds
    }
    
    /// Start the timer.
    func startSpeaking() {
        timerStopped = false
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            self?.update()
        }
        timer?.tolerance = 0.1
        startDate = Date()
    }
    
    /// Stop the timer.
    func stopSpeaking() {
        timer?.invalidate()
        timerStopped = true
    }

    nonisolated private func update() {
        Task { @MainActor in
            guard let startDate,
                  !timerStopped else { return }
            let secondsElapsed = Int(Date().timeIntervalSince1970 - startDate.timeIntervalSince1970)
            self.secondsElapsed = secondsElapsed
            
            secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)
        }
    }
    
    func reset(lengthInMinutes: Int) {
        self.lengthInMinutes = lengthInMinutes
        secondsRemaining = lengthInSeconds
    }
}
