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
    
    static func load() async throws -> [Profile] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let profiles):
                    continuation.resume(returning: profiles)
                }
            }
        }
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
    
    @discardableResult
    static func save(profiles: [Profile]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(profiles: profiles) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let profilesSaved):
                    continuation.resume(returning: profilesSaved)
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
