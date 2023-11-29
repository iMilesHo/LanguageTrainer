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
    static var modelAudioFilePath: URL {
        let fileManager = FileManager.default
        let documentDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectory.appendingPathComponent("ModelAudio")
    }
    var modelAudioFileName: String
    
    init(id: String = "\(UUID())", topic: String, topicContent: String, lengthInMinutes: Int, theme: Theme, modelAudioFileName: String) {
        self.id = id
        self.topic = topic
        self.topicContent = topicContent
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
        self.modelAudioFileName = modelAudioFileName
    }
    
    static var emptyTopic: EnglishPracticeTopic {
        EnglishPracticeTopic(topic: "", topicContent: "...", lengthInMinutes: 0, theme: .sky, modelAudioFileName: "")
    }
}

extension EnglishPracticeTopic {
    static let sampleData: [EnglishPracticeTopic] = [
        EnglishPracticeTopic(id: "20231102flyingcats", topic: "Flying cats", topicContent: readingMaterials, lengthInMinutes: 3, theme: .orange, modelAudioFileName: "thegreatwallAudio.m4a"),
        EnglishPracticeTopic(id: "20231102thegreatwall", topic: "The Great Wall", topicContent: readingMaterials, lengthInMinutes: 3, theme: .buttercup, modelAudioFileName: "thegreatwallAudio.m4a"),
        EnglishPracticeTopic(id: "20231102canadagoose", topic: "Canada Goose", topicContent: readingMaterials, lengthInMinutes: 3, theme: .poppy, modelAudioFileName: "canadagooseAudio.m4a")
    ]
}



let readingMaterials = """
Cats never fail to fascinate human beings. They can be friendly and affectionate towards humans, but they lead mysterious lives of their own as well. They never become submissive like dogs and horses. As a result, humans have learned to respect feline independence. Most cats remain suspicious of humans all their lives. One of the things that fascinates us most about cats is the popular belief that they have nine lives. Apparently, there is a good deal of truth in this idea. A cat's ability to survive falls is based on fact.

Recently the New York Animal Medical Centre made a study of 132 cats over a period of five months. All these cats had one experience in common: they had fallen off high buildings, yet only eight of them died from shock or injuries. Of course, New Yorkis the ideal place for such an interesting study, because there is no shortage of tall buildings. There are plenty of high-rise windowsills to fall, from! One cat, Sabrina, fell 32 storeys, yet only suffered from a broken tooth. ‘Cats behave like well-trained paratroopers, ’ a doctor said. It seems that the further cats fall, the less they are likely to injure themselves. In a long drop, they reach speeds of 60 miles an hour and more. At high speeds, falling cats have time to relax. They stretch out their legs like flying squirrels. This increases their air-resistance and reduces the shock of impact when they hit the ground.
"""
