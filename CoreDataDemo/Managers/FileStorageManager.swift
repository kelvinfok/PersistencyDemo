//
//  FileStorageManager.swift
//  CoreDataDemo
//
//  Created by Kelvin Fok on 7/12/18.
//  Copyright © 2018 kelvinfok. All rights reserved.
//

import Foundation

class FileStorageManager {
    
    enum Directory {
        case documents
        case caches
    }
    
    static func getUrl(for directory: Directory) -> URL {
        
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        return FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first!
    }
    
    static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) {
        
        let url = getUrl(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        print(url.absoluteString)
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            removeItemIfPresent(at: url)
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch(let error) {
            print(error)
        }
    }
    
    static func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T {
        
        let url = getUrl(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        // Check if file exists
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File at path \(url.path) does not exist!")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(url.path)!")
        }
    }
    
    static func removeItemIfPresent(at url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    //  Remove all files at specified directory
    static func clear(_ directory: Directory) {
        let url = getUrl(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func remove(_ fileName: String, from directory: Directory) {
        let url = getUrl(for: directory).appendingPathComponent(fileName, isDirectory: false)
        removeItemIfPresent(at: url)
    }
    
}
