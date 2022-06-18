//
//  ContentView.swift
//  RVC
//
//  Created by John Peden on 6/18/22.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var seconds: String = ""
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    @State private var errorMessage: String = ""
    
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
                case .failure(_): errorMessage = "Error importing video"
                }
            }
            
            Text(errorMessage)
                .foregroundColor(.red)
            
            Button("Export video") {
                exportMovie(movie: movie)
            }
        }
    }
    
    private func exportMovie(movie: URL?) {
        if let mov = movie {
            let asset = AVAsset(url: mov)
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            
            let start = 1
            let end = 3
            
            guard
                let exportSession = AVAssetExportSession(
                asset: asset,
                presetName: AVAssetExportPresetHighestQuality)
            else {
                return
            }
            
            exportSession.outputURL = try! FileManager.default.url(
                for: .desktopDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ).appendingPathComponent("trimmed_video.mp4")
            
            exportSession.outputFileType = .mp4
            
            let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                    print("exported at Desktop")
                case .failed:
                    errorMessage = "failed to export"
                    
                case .cancelled:
                    errorMessage = "cancelled export"
                    
                default: break
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
