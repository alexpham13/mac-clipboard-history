//
//  ContentView.swift
//  Clipboard History
//
//  Created by Alex Pham on 9/3/26.
//

import SwiftUI
import AppKit

enum ClipboardType: Codable {
    case text
    case image
}

struct ClipboardItem: Codable, Identifiable {
    var type: ClipboardType
    var text: String?
    var imageData: Data?
    var id = UUID()
    
}
struct ContentView: View {
    @State var clipboardHistory: [ClipboardItem] = []
    @State var previousChangeCount: Int = 0
    @State var clipboardTimer: Timer? = nil
    let pasteboard = NSPasteboard.general
    
    func checkClipboard () {
        if previousChangeCount != pasteboard.changeCount {
            let copiedText = pasteboard.string(forType: .string)
            if let text = copiedText {
                if let index = clipboardHistory.firstIndex(where: {$0.text == text}) {
                    clipboardHistory.remove(at: index)
                }
                                clipboardHistory.insert(ClipboardItem (type: .text, text: text, imageData: nil), at: 0)
                if clipboardHistory.count > 50 {
                    clipboardHistory.removeLast()
                }
                saveHistory()
            }
            if let imageData = pasteboard.data(forType: .tiff) {
                if let index = clipboardHistory.firstIndex(where: { $0.imageData == imageData }) {
                    clipboardHistory.remove(at: index)
                }
                clipboardHistory.insert(ClipboardItem (type: .image, text: nil, imageData: imageData), at: 0)
                if clipboardHistory.count > 50 {
                    clipboardHistory.removeLast()
                }
                saveHistory()
            }
            previousChangeCount = pasteboard.changeCount
        }
    }
    func saveHistory() {
        if let data = try? JSONEncoder().encode(clipboardHistory) {
            UserDefaults.standard.set(data, forKey: "savedClipboardHistory")
        }
    }
    func loadHistory() {
        if let savedHistory =
            UserDefaults.standard.data(forKey: "savedClipboardHistory") {
            if let decodedHistory = try?
                JSONDecoder().decode([ClipboardItem].self, from: savedHistory) {
                clipboardHistory = decodedHistory
            }
        }
    }
    
    func rowBackground(item: String) -> Color {
        if item == pasteboard.string(forType: .string) {
            return Color.blue.opacity(0.15)
        } else { return Color.clear
        }
    }
    func imageRowBackground(imageData: Data) -> Color {
        if imageData == pasteboard.data(forType: .tiff) {
            return Color.blue.opacity(0.15)
        } else { return Color.clear
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
                
                ForEach(clipboardHistory) {item in
                    
                    if let text = item.text {
                        HStack {
                            
                            Button {
                                pasteboard.clearContents()
                                pasteboard.setString(text, forType: .string)
                            } label: {
                                Text(text)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                            
                            Button {
                                if let index = clipboardHistory.firstIndex(where: { $0.id == item.id}) {
                                    clipboardHistory.remove(at: index)
                                    saveHistory()
                                }
                            } label: {
                                Label ("Delete", systemImage: "trash")
                                
                            }
                        }
                        
                        .padding(.vertical, 8)
                        .background(rowBackground(item: text))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        Divider()
                    }
                    if let imageData = item.imageData {
                        if let image = NSImage(data: imageData) {
                            Button {
                                pasteboard.clearContents()
                                pasteboard.setData(imageData, forType: .tiff)
                            } label: {
                                HStack {
                                    
                                    Image(nsImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 150)
                                    Spacer()
                                    
                                    Button {
                                        if let index = clipboardHistory.firstIndex(where: { $0.id == item.id }) {
                                            clipboardHistory.remove(at: index)
                                        saveHistory()
                                        }
                                    } label: {
                                        Label ("Delete", systemImage: "trash")
                                    }
                                }
                                .background(imageRowBackground(imageData: imageData))
                            }
                        }
                    }
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
