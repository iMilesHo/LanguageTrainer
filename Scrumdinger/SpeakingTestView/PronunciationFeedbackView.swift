//
//  PronunciationFeedbackView.swift
//  Scrumdinger
//
//  Created by YuanlaiHe on 2023-11-14.
//

import SwiftUI

struct PronunciationFeedbackView: View {
    var score: Int // 分数
    var feedback: [String] // 反馈的句子片段
    @Binding var isPresentingView: Bool

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Score")) {
                    Text("\(score)/100")
                }
                
                Section(header: Text("Feedback")) {
                    ForEach(feedback, id: \.self) { sentence in
                        Text(sentence)
                    }
                }
            }
            .navigationTitle("Pitch Feedback")
            .navigationBarItems(trailing: Button("Done") {
                // 这里处理关闭弹窗的逻辑
                isPresentingView.toggle()
            })
        }
    }
}

struct PronunciationFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        PronunciationFeedbackView(score: 80, feedback: ["The Great Wall of China, ", "a marvel of engineering stretching over"], isPresentingView: .constant(true))
    }
}
