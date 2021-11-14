//
//  Power_GridApp.swift
//  Power Grid WatchKit Extension
//
//  Created by Elliot Tormey on 14/11/2021.
//

import SwiftUI

@main
struct PowerGridApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
                ContentView(viewModel: MainViewModel())
                    .edgesIgnoringSafeArea(.all)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
