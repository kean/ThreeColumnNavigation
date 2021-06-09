//
//  TestSidebarApp.swift
//  TestSidebar
//
//  Created by Alexander Grebenyuk on 15.02.2021.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

@main
struct TestSidebarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Uncomment to hide title
        // .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
        .commands {
            SidebarCommands()
        }
    }
}

struct ContentView: View {

    var body: some View {
        NavigationView {
            Sidebar()
            Text("No Sidebar Selection")
            Text("No Message Selection")
        }
        .onAppear {
            #if canImport(UIKit)
            // Setting up iPad layout to match macOS behaviour
            UIApplication.shared.setFirstSplitViewPreferredDisplayMode(.twoBesideSecondary)
            #endif
        }
    }
}

struct Sidebar: View {
    @State private var isDefaultItemActive = true

    var body: some View {
        let list = List {
            Text("Favorites")
                .font(.caption)
                .foregroundColor(.secondary)
            NavigationLink(destination: IndoxView(), isActive: $isDefaultItemActive) {
                Label("Inbox", systemImage: "tray.2")
            }
            NavigationLink(destination: SentView()) {
                Label("Sent", systemImage: "paperplane")
            }
        }
        .listStyle(SidebarListStyle())

        #if os(macOS)
        list.toolbar {
            Button(action: toggleSidebar) {
                Image(systemName: "sidebar.left")
            }
        }
        #else
        list
        #endif
    }
}

#if os(macOS)
private func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?
        .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}
#endif

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Consistency with iPad

#if canImport(UIKit)
private extension UIApplication {
    func setFirstSplitViewPreferredDisplayMode(_ preferredDisplayMode: UISplitViewController.DisplayMode) {
        var splitViewController: UISplitViewController? {
            UIApplication.shared.firstSplitViewController
        }
        
        // Sometimes split view is not available instantly
        if let splitViewController = splitViewController {
            splitViewController.preferredDisplayMode = preferredDisplayMode
        } else {
            DispatchQueue.main.async {
                splitViewController?.preferredDisplayMode = preferredDisplayMode
            }
        }
    }
    
    private var firstSplitViewController: UISplitViewController? {
        windows.first { $0.isKeyWindow }?
            .rootViewController?.firstSplitViewController
    }
}

private extension UIViewController {
    var firstSplitViewController: UISplitViewController? {
        self as? UISplitViewController
            ?? children.lazy.compactMap { $0.firstSplitViewController }.first
    }
}
#endif
