//
//  EventsInteractor.swift
//  HearXProject
//
//  Created by Mihlali Mazomba on 2023/03/05.
//

import Foundation

enum ServiceError: Error {
    case serviceError
    case decodingError
    case corruptData
    case badURL
    case badImage
    case emptyList
}

enum UploadResult: Codable {
    case success
    case failure(error: String)
}

struct Body: Codable {
    var mode: String
    var raw: String
}

struct UploadRequest: Codable {
    var body: Body
}


protocol ResultsProtocol {
    func upload(userResult: String, completion: @escaping (Result<[UploadResult], ServiceError> ) -> Void)
}

class EventsInteractor: ResultsProtocol {
    
    func upload(userResult testResult: String, completion: @escaping (Result<[UploadResult], ServiceError> ) -> Void) {
        
        let stringUrl = "https://enoqczf2j2pbadx.m.pipedream.net"
        

        guard let requestUrl = URL(string:  stringUrl) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let testResult = UploadRequest(body: Body(mode: "raw", raw: testResult))
        let jsonData = try? JSONEncoder().encode(testResult)
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.serviceError))
                return
            }
            guard let data = data else {
                completion(.failure(.corruptData))
                return
            }

            let decoder = JSONDecoder()
    
            guard let decodedData = try? decoder.decode([UploadResult].self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            completion(.success(decodedData))
        }.resume()
    }
}
