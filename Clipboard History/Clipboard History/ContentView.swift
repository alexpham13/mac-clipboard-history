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
            previousChangeCount = pasteboard.changeCount
        }
    }
    var body: some View {
        let copiedText = pasteboard.string(forType: .string)
        if let text = copiedText {
            Text(text)
        
        }
        VStack {
            Text("Clipboard History")
            if clipboardHistory.isEmpty {
                Text("No Clipboard Items Yet")
            }
        HStack {
            Button("Add test item") {
                clipboardHistory.insert("Test Item \(clipboardHistory.count + 1)"
                                        , at: 0)
            }
            
                
            Button("Remove test item") {
                if !clipboardHistory.isEmpty {
                    clipboardHistory.remove(at: 0)
                }
            }
                }
    
            ForEach(clipboardHistory, id: \.self) {item in
            Text(item)}
    Text("Items: \(clipboardHistory.count)")        }
        
        Button("Clear History") {
            clipboardHistory.removeAll()
        }
        .padding()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                checkClipboard()
            }
        }
    }
}
#Preview {
    ContentView()
}
