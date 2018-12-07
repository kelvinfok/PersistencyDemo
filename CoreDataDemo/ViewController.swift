//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Kelvin Fok on 7/12/18.
//  Copyright © 2018 kelvinfok. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let persistenceManager = PersistenceManager.shared
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 Clear File Storage
        // FileStorageManager.clear(.documents)
        // 2. save image into NSUserDefaults
        // saveImageIntoDefaults()
        // 3. Display Model onto file
        // saveModelIntoFile()
        
        // 4. Download video and play
        // downloadVideoAndPlay()
        
        // createUser()
        getUser()
        deleteUser()
        
    }
    
    func updateUsers() {
        let firstUser = users.first!
        firstUser.name += " - YO updated bro"
        persistenceManager.save()
        printUsers()
    }
    
    func createUser() {
        let user = User(context: persistenceManager.context)
        user.name = "Ali"
        persistenceManager.save()
    }
    
    func getUser() {
        let users = persistenceManager.fetch(User.self)
        self.users = users
        printUsers()
        let deadline = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            // self.updateUsers()
        }
    }
    
    func deleteUser() {
        let firstUser = users.first!
        persistenceManager.delete(firstUser)
        printUsers()
    }
    
    func printUsers() {
        users.forEach({ print($0.name) })
    }
    
    func downloadVideoAndPlay() {
        APIManager.saveVideo { (url) in
            OperationQueue.main.addOperation {
                let player = AVPlayer(url: url)
                let vc = AVPlayerViewController()
                vc.player = player
                self.present(vc, animated: true) {
                    vc.player?.play()
                }
            }
        }
    }
    
    func saveModelIntoFile() {
        let sweetImage = Image(description: "Some scenery", image: #imageLiteral(resourceName: "image").pngData()!)
        FileStorageManager.store(sweetImage, to: .documents, as: "scenery.json")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let _sweetImage = FileStorageManager.retrieve("scenery.json", from: .documents, as: Image.self)
            self.imageView.image = UIImage(data: _sweetImage.image)
            self.label.text = _sweetImage.description
        }
    }
    
    func saveImageIntoDefaults() {
        let image = #imageLiteral(resourceName: "image")
        let data = image.pngData()!
        StorageManager().save(data: data, key: .image)
        if let imageData = StorageManager().retrieve(key: .image) as? Data {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }
}

struct Image: Codable {
    
    var description: String
    var image: Data
    
}
