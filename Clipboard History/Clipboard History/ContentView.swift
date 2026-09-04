//
//  ContentView.swift
//  Clipboard History
//
//  Created by Alex Pham on 9/3/26.
//

import SwiftUI

struct ContentView: View {
    @State var testItem = 0
    var body: some View {
        VStack {
            Text("Clipboard History")
            if testItem == 0 {
                Text("No Clipboard Items Yet")
            }
            HStack {
                Button("Add test item") {
                    testItem = testItem + 1
                }
                
                
                
                Button("Remove test item") {
                    if testItem > 0 {
                        testItem = testItem - 1
                    }
                }
                
            }
            Text("Items \(testItem)")
        }
        .padding()
    }
}
#Preview {
    ContentView()
}
