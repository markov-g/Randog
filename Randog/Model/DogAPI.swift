//
//  DogAPI.swift
//  Randog
//
//  Created by Georgi Markov on 8/7/21.
//

import UIKit

class DogAPI {
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForSpecificBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
                case .randomImageFromAllDogsCollection:
                    return "https://dog.ceo/api/breeds/image/random"
                case .randomImageForSpecificBreed(let breed):
                    return "https://dog.ceo/api/breed/\(breed)/images/random"
                case .listAllBreeds:
                    return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndoint = DogAPI.Endpoint.randomImageForSpecificBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImageEndoint) { data, response, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData, nil)
        }
        task.resume()
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { imageData, imageResponse, imageError in
            guard let imageData = imageData else {
                completionHandler(nil, imageError)
                return
            }
            let downloadedImage = UIImage(data: imageData)
            
            completionHandler(downloadedImage, nil)
        }
        task.resume()
    }
    
    class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void) -> Void{
        let breedsListEndpoint = DogAPI.Endpoint.listAllBreeds.url
        let task = URLSession.shared.dataTask(with: breedsListEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
            let breeds = breedsResponse.message.keys.map { breed in
                return breed
            }
            
            completionHandler(breeds, nil)
        }
        task.resume()
    }
}
