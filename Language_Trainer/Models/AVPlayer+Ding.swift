/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation
import AVFoundation

extension AVPlayer {
    static let sharedDingPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
}


import AVFoundation
import Speech

class AudioRecorderAndTranscriber: NSObject, AVAudioRecorderDelegate, SFSpeechRecognizerDelegate {
    
    private var audioRecorder: AVAudioRecorder?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // 为每次录音创建唯一的文件名
    private var currentFileName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return "recording-\(dateFormatter.string(from: Date())).m4a"
    }
    
    // 文字更新回调
    var onTranscription: ((String) -> Void)?
    
    // 错误回调
    var onError: ((Error) -> Void)?
    
    // 初始化设置
    override init() {
        super.init()
        speechRecognizer.delegate = self
    }
    
    // 开始录音和转写
    func startRecording() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // 确保权限被授权
            guard authStatus == .authorized else {
                self.onError?(NSError(domain: "SFSpeechRecognizer", code: authStatus.rawValue, userInfo: nil))
                return
            }
            
            // 配置录音会话
            do {
                try self.startAudioSession()
                try self.startRecordingAudio()
                try self.startSpeechRecognition()
            } catch {
                self.onError?(error)
            }
        }
    }
    
    // 设置并启动AVAudioSession
    private func startAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    // 开始录音
    private func startRecordingAudio() throws {
        let recordingURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(currentFileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.record()
    }
    
    // 开始语音转写
    private func startSpeechRecognition() throws {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else { throw NSError(domain: "AudioRecorderAndTranscriber", code: 1, userInfo: nil) }
        recognitionRequest.shouldReportPartialResults = true
        
        // 将录音输入添加到语音识别器
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // 开始语音识别任务
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let transcribedText = result.bestTranscription.formattedString
                self.onTranscription?(transcribedText)
            }
            if let error = error {
                self.onError?(error)
                self.stopRecording()
            }
        }
    }
    
    // 停止录音和转写
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        audioRecorder?.stop()
        audioRecorder = nil
        recognitionTask = nil
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            onError?(NSError(domain: "AVAudioRecorder", code: 0, userInfo: [NSLocalizedDescriptionKey: "录音未能成功完成。"]))
        }
    }
    
    // MARK: - SFSpeechRecognizerDelegate
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            onError?(NSError(domain: "SFSpeechRecognizer", code: 0, userInfo: [NSLocalizedDescriptionKey: "语音识别不可用。"]))
        }
    }
}
