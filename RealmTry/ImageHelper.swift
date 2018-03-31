//
//  ImageHelper.swift
//  RealmTry
//
//  Created by Luis  Costa on 31/03/18.
//  Copyright © 2018 Luis  Costa. All rights reserved.
//

import UIKit

enum ImageTypeSaved {
    case png
    case jpeg(compressionQuality: CGFloat)
}

class ImageHelper {
    
    fileprivate static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func loadImage(withName name: String) -> UIImage? {
        let url = self.getDocumentsDirectory().appendingPathComponent(name)
        do {
            let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            return image
        }
        catch { return nil }
    }
    
    static func deleteImage(withName name: String) -> Bool {
        let url = self.getDocumentsDirectory().appendingPathComponent(name)
        do { try FileManager().removeItem(at: url) }
        catch { return false }
        
        return true
    }
    
    
    static func save(image: UIImage, with type: ImageTypeSaved) -> String? {
        let identifier = UUID().uuidString
        let data: Data!
        
        switch type {
        case .png:
            data = UIImagePNGRepresentation(image)
        
        case .jpeg(let compression):
            if compression < 0 || compression > 1 { return nil }
            data = UIImageJPEGRepresentation(image, compression)
        }
        
        guard let dataImage = data else { return nil }
        
        let filename = getDocumentsDirectory().appendingPathComponent(identifier)
        do { try  dataImage.write(to: filename) }
        catch { return nil }
        
        return identifier
    }
}
