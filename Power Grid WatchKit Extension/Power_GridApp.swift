//
//  Power_GridApp.swift
//  Power Grid WatchKit Extension
//
//  Created by Fred on 14/11/2021.
//

import SwiftUI

@main
struct Power_GridApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
