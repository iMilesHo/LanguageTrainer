//
//  EnglishPracticeTopic.swift
//  Scrumdinger
//
//  Created by YuanlaiHe on 2023-11-02.
//

import Foundation

struct EnglishPracticeTopic: Identifiable, Codable   {
    let id: String
    var topic: String
    var topicContent: String
    var lengthInMinutes: Int
    var lengthInMinutesAsDouble: Double {
        get {
            Double(lengthInMinutes)
        }
        set {
            lengthInMinutes = Int(newValue)
        }
    }
    var theme: Theme
    var recordeHistory: [RecordingHistory] = []
    
    init(id: String = "\(UUID())", topic: String, topicContent: String, lengthInMinutes: Int, theme: Theme) {
        self.id = id
        self.topic = topic
        self.topicContent = topicContent
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
    
    static var emptyTopic: EnglishPracticeTopic {
        EnglishPracticeTopic(topic: "", topicContent: "...", lengthInMinutes: 0, theme: .sky)
    }
}

extension EnglishPracticeTopic {
    static let sampleData: [EnglishPracticeTopic] = [
        EnglishPracticeTopic(id: "20231102thegreatwall", topic: "The Great Wall", topicContent: readingMaterials, lengthInMinutes: 3, theme: .orange),
        EnglishPracticeTopic(id: "20231102canadagoose", topic: "Canada Goose", topicContent: readingMaterials, lengthInMinutes: 3, theme: .poppy)
    ]
}



let readingMaterials = """
The Great Wall of China, a marvel of engineering stretching over 13,000 miles, is a series of fortifications made of stone, brick, tamped earth, wood, and other materials. It was constructed over several centuries, beginning as early as the 7th century BC, with the most renowned portions built during the Ming Dynasty (1368–1644 AD). Initially erected by various states to protect against northern invasions, the Wall was later unified and expanded to defend the Chinese Empire against nomadic tribes. Its winding path over rugged country and steep mountains showcases the ancient world's immense determination and resourcefulness. Today, the Great Wall stands as a UNESCO World Heritage site and a symbol of China’s historical resilience, although it faces challenges such as erosion and damage from tourism and development.
"""
