//
//  SpeakingTestMainView.swift
//  Scrumdinger
//
//  Created by YuanlaiHe on 2023-11-02.
//

import SwiftUI
import AVFoundation

struct TitleView: View {
    let topic: String
    var body: some View {
        Text(topic)
            .font(.title)
            .foregroundColor(.black)
    }
}

struct ReadingPracticeView: View {
    let textToRead: String // The text that the user will read aloud
    @Binding var isRecording: Bool
    private let maxHeight: CGFloat = 500 // Maximum height for the scroll view
    var playAction: (_ isPlaying: Bool) -> Void // 用于播放音频的动作
    @State private var isPlaying: Bool = false // 追踪播放状态
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                Text(textToRead)
                    .padding()
                    .foregroundColor(.primary)
            }
            .frame(maxHeight: maxHeight)
            ScrollIndicatorView()
                .padding(.top, 8)
                .padding(.bottom, 8)
            HStack{
                Spacer()
                PlayButtonView(isPlaying: isPlaying, action: {
                    isPlaying.toggle()
                    playAction(isPlaying)
                })
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isRecording ? Color.red : Color.secondary, lineWidth: 2)
        )
    }
}
struct ScrollIndicatorView: View {
    var body: some View {
        HStack {
            Image(systemName: "arrow.down")
            Text("Scroll to see more")
        }
        .padding(4)
        .font(.caption)
        .foregroundColor(.white)
        .background(Color.black.opacity(0.5)) // 半透明黑色背景
        .cornerRadius(10)
    }
}

struct PlayButtonView: View {
    var isPlaying: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isPlaying ? "stop.circle" : "play.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
        }
    }
}


struct SpeakingTestMainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Binding var englishPracticeTopics: [EnglishPracticeTopic]
    @StateObject var speakingTimer = EnglishSpeakingTimer()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var recordingState: RecordingState = .readyToRecord
    @State private var showingHistory = false
    @State private var showingTopicInfo = false
    @State private var addingNewTopic = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showingFeedback = false
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    let saveAction: ()->Void
    
    var body: some View {
        NavigationView {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(englishPracticeTopics[0].theme.mainColor)
            VStack {
//                TitleView(topic: "The Great Wall")
//                    .padding(.top, 8)
                MeetingHeaderView(secondsElapsed: speakingTimer.secondsElapsed, secondsRemaining: speakingTimer.secondsRemaining, theme: englishPracticeTopics[0].theme)
                    .padding(.bottom, 16)
                ReadingPracticeView(textToRead: englishPracticeTopics[0].topicContent, isRecording: $isRecording, playAction:{isPlaying in 
                    if isPlaying {
                        playModelAudio()
                    } else {
                        audioPlayer?.stop()
                    }
                    
                })
                    .padding(.horizontal,8)
                RecordingButtonView(
                    recordingState: $recordingState,
                    onStartRecording: {
                        startRecording()
                    },
                    onStopRecording: {
                        stopRecording()
                    },
                    onPlay:{
                        playRecording()
                    },
                    onStopPlaying:{
                        stopPlaying()
                    },
                    onReRecord: {
                        startRecording() // 重新录音
                    },
                    onUpload: {
                        uploadRecording()
                    }
                )
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .foregroundColor(englishPracticeTopics[0].theme.accentColor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    showingHistory.toggle()
                }) {
                    Label("History", systemImage: "clock")
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showingTopicInfo.toggle()
                }) {
                    Label("Info", systemImage: "info.circle")
                }
                Button(action: {
                    addingNewTopic.toggle()
                }) {
                    Label("Add", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .principal) {
                Text(englishPracticeTopics[0].topic)
                    .font(.title)
                    .foregroundColor(.black)
            }
        }
        .sheet(isPresented: $showingHistory) {
            // 历史视图内容
            TopicsView(topics: $englishPracticeTopics) {
                saveAction()
            }
        }
        .sheet(isPresented: $showingTopicInfo) {
            if !englishPracticeTopics.isEmpty {
                NavigationStack {
                    DetailView(topic: $englishPracticeTopics[0])
                }
            }
        }
        .sheet(isPresented: $addingNewTopic) {
            NewTopicSheet(topics: $englishPracticeTopics, isPresentingNewScrumView: $addingNewTopic)
        }
        .sheet(isPresented: $showingFeedback) {
            PronunciationFeedbackView(score: 80, feedback: ["The Great Wall of China, ", "a marvel of engineering stretching over"], isPresentingView: $showingFeedback)
        }
        }
        .onDisappear {
            endScrum()
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
    private func startScrum() {
        speakingTimer.reset(lengthInMinutes: englishPracticeTopics[0].lengthInMinutes)
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
        speakingTimer.startSpeaking()
    }
    
    private func endScrum() {
        speakingTimer.stopSpeaking()
        speechRecognizer.stopTranscribing()
        isRecording = false
        let newHistory = RecordingHistory(transcript: speechRecognizer.transcript, audioFilePathURL: speechRecognizer.audioFilePathURL)
        englishPracticeTopics[0].recordeHistory.insert(newHistory, at: 0)
    }
    
    private func startRecording() {
        // ... 开始录音的逻辑
        startScrum()
        recordingState = .recording
    }
    
    private func stopRecording() {
        // ... 停止录音的逻辑
        endScrum()
        recordingState = .finishedRecording
    }
    private func playRecording() {
        recordingState = .playing
        // 启动播放录音的逻辑
        playAudio()
    }
    
    private func stopPlaying() {
        recordingState = .finishedRecording
        // 停止播放录音的逻辑
        audioPlayer?.stop()
    }
    
    private func uploadRecording() {
        // ... 上传录音的逻辑
        recordingState = .uploading
        // 假设上传是一个异步的过程，这里是模拟上传完成后的回调
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            recordingState = .uploaded
            showingFeedback = true
        }
    }
    
    private func playAudio() {
        do {
            guard let audioFileURL = englishPracticeTopics[0].recordeHistory[0].audioFilePathURL else {
                return
            }
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.play()
        } catch {
            // Handle the error of audio playback
            print("播放音频失败: \(error.localizedDescription)")
        }
    }
    
    private func playModelAudio() {
        do {
            let modelAudioFileName = englishPracticeTopics[0].modelAudioFileName
            let modelAudioFilePath = EnglishPracticeTopic.modelAudioFilePath
            if !FileManager.default.fileExists(atPath: modelAudioFilePath.path) {
                try FileManager.default.createDirectory(at: modelAudioFilePath, withIntermediateDirectories: true)
            }
            let fullPath = modelAudioFilePath.appendingPathComponent(modelAudioFileName)
            audioPlayer = try AVAudioPlayer(contentsOf: fullPath)
            audioPlayer?.play()
        } catch {
            // Handle the error of audio playback
            print("播放音频失败: \(error.localizedDescription)")
        }
    }
}

struct SpeakingTestMainView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakingTestMainView(englishPracticeTopics: .constant(EnglishPracticeTopic.sampleData), saveAction: {})
    }
}



enum RecordingState {
    case readyToRecord
    case recording
    case finishedRecording
    case playing
    case uploading
    case uploaded
}

struct RecordingButtonView: View {
    @Binding var recordingState: RecordingState
    var onStartRecording: () -> Void
    var onStopRecording: () -> Void
    var onPlay: () -> Void
    var onStopPlaying: () -> Void
    var onReRecord: () -> Void
    var onUpload: () -> Void
    
    var body: some View {
        VStack {
            switch recordingState {
            case .readyToRecord, .finishedRecording:
                Button(action: {
                    if recordingState == .readyToRecord {
                        onStartRecording()
                    } else {
                        onReRecord()
                    }
                }) {
                    labelForButton(recordingState)
                }
                .buttonStyle(.borderedProminent)
                
            case .recording:
                Button("Stop Recording", action: onStopRecording)
                    .buttonStyle(.borderedProminent)
                
            case .playing:
                Button("Stop Playback", action: onStopPlaying)
                    .buttonStyle(.borderedProminent)
                
            case .uploaded, .uploading:
                // 在上传时不显示按钮或显示上传状态
                if recordingState == .uploading {
                    Text("Uploading...")
                } else {
                    Button("Re-record", action: onReRecord)
                        .buttonStyle(.bordered)
                }
            }
            
            // 如果已经完成录音，显示上传和播放按钮
            if recordingState == .finishedRecording {
                Button("Upload and Get Feedback", action: onUpload)
                    .buttonStyle(.bordered)
                
                Button("Play Recording", action: onPlay)
                    .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    private func labelForButton(_ state: RecordingState) -> Text {
        switch state {
        case .readyToRecord:
            return Text("Start Recording")
        case .finishedRecording:
            return Text("Re-record")
        default:
            return Text("") // 其他状态不显示这个按钮
        }
    }
}
