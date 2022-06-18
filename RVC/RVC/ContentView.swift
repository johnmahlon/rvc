//
//  ContentView.swift
//  RVC
//
//  Created by John Peden on 6/18/22.
//

import SwiftUI

struct ContentView: View {
    @State private var seconds: String = ""
    @State private var isImporting: Bool = false
    @State private var showImportError: Bool = false
    
    @State private var movie: URL? = nil
    
    var body: some View {
        VStack {
            Text("How many seconds?")
            TextField("", text: $seconds)
                .frame(width: 125)
            Button("Import Video") {
                isImporting.toggle()
            }.fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.movie]
            ) { result in
                switch result {
                case .success(let url): movie = url
                case .failure(_): showImportError = true
                }
            }
            
            Text("Error importing video :(")
                .foregroundColor(.red)
                .opacity(showImportError ? 0 : 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
