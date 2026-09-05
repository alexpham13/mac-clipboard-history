//
//  ContentView.swift
//  Clipboard History
//
//  Created by Alex Pham on 9/3/26.
//

import SwiftUI

struct ContentView: View {
    @State var clipboardHistory: [String] = []
    var body: some View {
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
    }
}
#Preview {
    ContentView()
}
