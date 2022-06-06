//
//  FileDownloadToMacOSAppsOpenAdapter.swift
//  DownloadFileDemo
//
//  Created by Arifin Firdaus on 06/06/22.
//

import AppKit

enum MacOSAppBundleId: String {
    case preview = "com.apple.Preview"
}

protocol OpenFileHandler {
    func openFile(url: URL)
}

final class FileDownloadToMacOSAppsOpenAdapter: OpenFileHandler {
    
    private let httpClient: HTTPClient
    private let workspace: NSWorkspace
    private let appBundleId: MacOSAppBundleId
    
    init(httpClient: HTTPClient, workspace: NSWorkspace, appBundleId: MacOSAppBundleId) {
        self.httpClient = httpClient
        self.workspace = workspace
        self.appBundleId = appBundleId
    }
    
    func openFile(url: URL) {
        let workspace = workspace
        let appBundleId = appBundleId.rawValue
        let savePanel = NSSavePanel()
        
        httpClient.downloadTask(from: url) { result in
            
            switch result {
            case .success(let localURL):
                
                DispatchQueue.main.async {
                    
                    savePanel.begin { modalResponse in
                        
                        if modalResponse.rawValue == NSApplication.ModalResponse.OK.rawValue {
                            let fileManager = FileManager.default
                            let downloadPath = fileManager.homeDirectoryForCurrentUser.appendingPathComponent("Downloads")
                            let fileName = "\(savePanel.nameFieldStringValue) - \(Date()).pdf"
                            let filePath = downloadPath.appendingPathComponent(fileName)
                            
                            do {
                                // FIXME: After tried to interact with `localURL` more than one times, it catches error
                                // e.g. The file “CFNetworkDownload_cLNnrE.tmp” couldn’t be opened because there is no such file.
                                // e.g. The file “CFNetworkDownload_IN5oTu.tmp” couldn’t be opened because there is no such file.
                                // ...
                                // Basically, it says that the .temp file does not exist, for unknown reason.
                                // The `localURL` is where the PDF file is downloaded locally.
                                try fileManager.copyItem(at: localURL, to: filePath)
                                
                                guard let previewAppURL = workspace.urlForApplication(withBundleIdentifier: appBundleId) else {
                                    return
                                }
                                
                                self.workspace.open(
                                    [filePath],
                                    withApplicationAt: previewAppURL,
                                    configuration: NSWorkspace.OpenConfiguration()
                                )
                            } catch {
                                let errorMessage = error.localizedDescription
                                print(errorMessage)
                            }
                        }
                    }
                    
                }
                
            case .failure:
                break
            }
        }
    }
}

final class OpenFileHandlerNullObject: OpenFileHandler {
    
    init() {}
    
    func openFile(url: URL) { }
}
