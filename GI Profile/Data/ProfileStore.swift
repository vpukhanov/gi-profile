//
//  GlobalStore.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 14/10/2022.
//

import Foundation
import SwiftUI

class ProfileStore: ObservableObject {
    @Published var profiles: [Profile] = []
    
    private static func fileURL() throws -> URL {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ru.pukhanov.GI-Profile")?
            .appendingPathComponent("profiles.json") else {
            throw URLError(.badURL)
        }
        return url
    }
    
    static func load(completion: @escaping (Result<[Profile], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let profiles = try JSONDecoder().decode([Profile].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(profiles))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(profiles: [Profile], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(profiles)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(profiles.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
