//
//  ContentView.swift
//  Clipboard History
//
//  Created by Alex Pham on 9/3/26.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State var clipboardHistory: [String] = []
    @State var previousChangeCount: Int = 0
    let pasteboard = NSPasteboard.general
  
    func checkClipboard () {
        if previousChangeCount != pasteboard.changeCount {
            let copiedText = pasteboard.string(forType: .string)
            if let text = copiedText {
                clipboardHistory.insert(text, at: 0)
                saveHistory()
            }
            previousChangeCount = pasteboard.changeCount
        }
    }
    func saveHistory() {
        UserDefaults.standard.set(clipboardHistory, forKey: "savedClipboardHistory")
    }
    func loadHistory() {
        if let savedHistory =
            UserDefaults.standard.array(forKey: "savedClipboardHistory") as? [String] {
            clipboardHistory = savedHistory
        }
        }
    
    var body: some View {
       
        VStack {
            Text("Clipboard History")
            if clipboardHistory.isEmpty {
                Text("No Clipboard Items Yet")
            }
                
            
            ForEach(clipboardHistory, id: \.self) {item in
                Button(item) {
                    pasteboard.clearContents()
                    pasteboard.setString(item, forType: .string)
                }
            }
                    Text("Items: \(clipboardHistory.count)")        }
            
        Button("Clear History") {
            clipboardHistory.removeAll()
        }
        .padding()
        .onAppear {
            loadHistory()
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                checkClipboard()
            }
        }
    }
}
#Preview {
    ContentView()
}
