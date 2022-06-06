//
//  ContentView.swift
//  DownloadFileDemo
//
//  Created by Arifin Firdaus on 06/06/22.
//

import SwiftUI

struct ContentView: View {
    
    let openFileHandler: OpenFileHandler
    private let pdfSource = "http://www.africau.edu/images/default/sample.pdf"
    
    var body: some View {
        Button {
            openFileHandler.openFile(url: URL(string: pdfSource)!)
        } label: {
            Text("Press to Download")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(openFileHandler: OpenFileHandlerNullObject())
    }
}
