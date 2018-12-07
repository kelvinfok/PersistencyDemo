//
//  NetworkingManager.swift
//  CoreDataDemo
//
//  Created by Kelvin Fok on 7/12/18.
//  Copyright © 2018 kelvinfok. All rights reserved.
//

import Foundation
import Photos

class APIManager: NSObject {
        
    static func saveVideo(completion: @escaping (URL) -> Void) {
        
        let url = URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!

        let task = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let url = url {
                do {
                    let urlData = try Data(contentsOf: url)
                    let videoUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("video.mp4", isDirectory: false)
                    try urlData.write(to: videoUrl)
                    print("videoURL: \(videoUrl.path)")
                    completion(videoUrl)
                } catch {
                    fatalError("No url data found!")
                }
            }
        }
        task.resume()
    }
}
