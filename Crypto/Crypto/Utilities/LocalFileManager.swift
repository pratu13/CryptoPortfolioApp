//
//  LocalFileManager.swift
//  Crypto
//
//  Created by Pratyush  on 6/17/21.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {}
    
    private func getURLForFolder(name: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(name)
    }
    
    private func getURLForImage(name: String, folderName: String) -> URL? {
         guard let folderURl = getURLForFolder(name: folderName) else {
             return nil
         }
         return folderURl.appendingPathComponent(name + ".png")
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(name: folderName) else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard let data = image.pngData(),
              let url = getURLForImage(name: imageName, folderName: folderName) else { return }

        do {
            try data.write(to: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(name: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        
        return UIImage(contentsOfFile: url.path)
    }
}
 
