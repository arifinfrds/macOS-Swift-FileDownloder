//
//  HTTPClient.swift
//  DownloadFileDemo
//
//  Created by Arifin Firdaus on 06/06/22.
//

import Foundation

protocol HTTPClient {
    func downloadTask(from url: URL, completion: @escaping (Result<URL, Error>) -> Void)
}

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func downloadTask(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        session.downloadTask(with: url) { url, _, _ in
            guard let localURL = url else {
                completion(.failure(NSError()))
                return
            }
            completion(.success(localURL))
        }
        .resume()
    }
}
