//
//  DownloadFileDemoApp.swift
//  DownloadFileDemo
//
//  Created by Arifin Firdaus on 06/06/22.
//

import SwiftUI

@main
struct DownloadFileDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                openFileHandler: FileDownloadToMacOSAppsOpenAdapter(
                    httpClient: URLSessionHTTPClient(session: URLSession(configuration: .ephemeral)),
                    workspace: NSWorkspace.shared,
                    appBundleId: MacOSAppBundleId.preview
                )
            )
        }
    }
}
