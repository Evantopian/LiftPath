//
//  ExceriseAPI_Fetch.swift
//  LiftPath
//
//  Created by Evan Huang on 12/6/24.
//



// Consider: Load Entire DB, then just fetch like that. Conserves but
// given 600 + do at end.

import Foundation

class ExerciseAPIFetcher {
    private static var exerciseCache: [String: [Exercise]] = [:]
    
    static func fetchExercises(for bodyPart: String, completion: @escaping ([Exercise]) -> Void) {
        if let cachedExercises = exerciseCache[bodyPart.lowercased()] {
            completion(cachedExercises)
            return
        }

        let headers = [
            "x-rapidapi-key": "ea4d4860d6msh63f88da1c3726a6p12db0bjsn52c1d017b0b6",
            "x-rapidapi-host": "exercisedb.p.rapidapi.com"
        ]
        
        let bodyPartLowercased = bodyPart.lowercased()
        let urlString = "https://exercisedb.p.rapidapi.com/exercises/bodyPart/\(bodyPartLowercased)?limit=10&offset=0"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 5.0

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    let fetchedExercises = json.compactMap { dict in
                        if let name = dict["name"] as? String,
                           let target = dict["target"] as? String,
                           let gifUrl = dict["gifUrl"] as? String {
                            return Exercise(name: name, target: target, gifUrl: gifUrl)
                        }
                        return nil
                    }
                    
                    // Cache the fetched data for future use
                    exerciseCache[bodyPartLowercased] = fetchedExercises
                    
                    DispatchQueue.main.async {
                        completion(fetchedExercises)
                    }
                } else {
                    print("Failed to parse JSON")
                    completion([])
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion([])
            }
        }
        dataTask.resume()
    }
}
