//
//  TestSidebarApp.swift
//  TestSidebar
//
//  Created by Alexander Grebenyuk on 15.02.2021.
//

import SwiftUI

@main
struct TestSidebarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    var body: some View {
        NavigationView {
            Sidebar()
            #if os(macOS)
            Text("No Sidebar Selection")
            #else
            IndoxView() // on iOS, isActive doesn't work (defect?)
            #endif
            Text("No Message Selection")
        }
    }
}

struct Sidebar: View {
    @State private var isDefaultItemActive = true

    var body: some View {
        List {
            Text("Favorites")
                .font(.caption)
                .foregroundColor(.secondary)
            NavigationLink(destination: IndoxView(), isActive: $isDefaultItemActive) {
                Label("Inbox", systemImage: "tray.2")
            }
            NavigationLink(destination: SentView()) {
                Label("Sent", systemImage: "paperplane")
            }
        }.listStyle(SidebarListStyle())
    }
}

struct IndoxView: View {
    var body: some View {
        List(allMessages, id: \.self) { message in
            NavigationLink(destination: MessageDetailsView(message: message)) {
                Text(message)
            }
        }
        .navigationTitle("Inbox")
        .toolbar {
            Button(action: { /* Open filters */ }) {
                Image(systemName: "line.horizontal.3.decrease.circle")
            }
        }
    }
}

struct SentView: View {
    var body: some View {
        Text("No Sent Messages")
            .navigationTitle("Sent")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }
    }
}

struct MessageDetailsView: View {
    let message: String

    var body: some View {
        Text("Details for \(message)")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
    }
}

let allMessages = Array(0...100).map(String.init)

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
