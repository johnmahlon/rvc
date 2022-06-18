//
//  RVCApp.swift
//  RVC
//
//  Created by John Peden on 6/18/22.
//

import SwiftUI

@main
struct RVCApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Import") {
                    print("importing video...")
                }.keyboardShortcut("i")
            }
        }
    }
}
