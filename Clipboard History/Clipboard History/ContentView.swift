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
    func rowBackground(item: String) -> Color {
        if item == pasteboard.string(forType: .string) {
            return Color.blue.opacity(0.15)
        }else{ return Color.clear
        }
    }
    
    var body: some View {
        
        VStack {
            HStack (spacing: 25) {
                Text("Clipboard History")
                    .font(.title)
                    .bold()
                    .lineLimit(1)
                Spacer ()
                
                Text("Items: \(clipboardHistory.count)")
            
                Button("Clear History", role: .destructive) {
                    clipboardHistory.removeAll()
                    saveHistory()
                }
                .foregroundStyle(Color(red: 0.9, green: 0.1, blue: 0.1))
            }
                if clipboardHistory.isEmpty {
                    VStack {
                        Image(systemName: "doc.on.clipboard")
                            .font(.largeTitle)
                        Text("No Clipboard Items Yet")
                    }
                    .foregroundStyle(.secondary)
                }
            
            ScrollView {
                
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
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        Button {
                            if let index = clipboardHistory.firstIndex(of: item) {
                                clipboardHistory.remove(at: index)
                                saveHistory()
                            }
                        } label: {
                            Label ("Delete", systemImage: "trash")
                            
                        }
                    }
                    .padding(.vertical, 8)
                    .background(rowBackground(item: item))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    Divider()
                    
                }
            }
                   }
        .frame(minWidth: 500)
        
        
        
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
