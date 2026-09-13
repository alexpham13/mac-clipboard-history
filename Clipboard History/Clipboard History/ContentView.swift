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
    @State var clipboardTimer: Timer? = nil
    let pasteboard = NSPasteboard.general
    
    func checkClipboard () {
        if previousChangeCount != pasteboard.changeCount {
            let copiedText = pasteboard.string(forType: .string)
            if let text = copiedText {
                if let index = clipboardHistory.firstIndex(of: text) {
                    clipboardHistory.remove(at: index)
                }
                clipboardHistory.insert(text, at: 0)
                if clipboardHistory.count > 50 {
                    clipboardHistory.removeLast()
                }
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
            HStack {
                Text("Clipboard History")
                    .font(.title)
                    .bold()
                Spacer ()
                
                Button("Clear History") {
                    clipboardHistory.removeAll()
                    saveHistory()
                }
            }
                if clipboardHistory.isEmpty {
                    Text("No Clipboard Items Yet")
                }
            
            
            ForEach(clipboardHistory, id: \.self) {item in
                
                HStack {
                    
                    Button {
                        pasteboard.clearContents()
                        pasteboard.setString(item, forType: .string)
                    } label: {
                        Text(item)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Button("Delete") {
                        if let index = clipboardHistory.firstIndex(of: item) {
                            clipboardHistory.remove(at: index)
                            saveHistory()
                        }
                    }
                }
                .padding(.vertical, 6)
                Divider()
            }
            Text("Items: \(clipboardHistory.count)")        }
        
        
        
        .onAppear {
            loadHistory()
            previousChangeCount = pasteboard.changeCount
            clipboardTimer =
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                checkClipboard()
            }
        }
        .onDisappear() {
            clipboardTimer?.invalidate()
            clipboardTimer = nil
        }
    }
}
#Preview {
    ContentView()
}
