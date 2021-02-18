# Triple Trouble

A minimal example of three-column navigation for iPad and macOS using SwiftUI.

See [the post](https://kean.blog/post/triple-trouble) for more info.

> **WARNING**: This solution requires Big Sur.

## Code

```swift
import SwiftUI

@main
struct BestApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    var body: some View {
        NavigationView {
            Sidebar()
            Text("No Sidebar Selection")
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
        List(Array(0...100).map(String.init), id: \.self) { message in
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
```

## Screenshot

<br/>

![Screen Shot 2021-02-15 at 14 38 54](https://user-images.githubusercontent.com/1567433/107989973-6c295d00-6fa1-11eb-8e89-935571a4f47a.png)

<br/>

![Screen Shot 2021-02-15 at 14 35 30](https://user-images.githubusercontent.com/1567433/107989972-6b90c680-6fa1-11eb-98b2-4caa368963de.png)
