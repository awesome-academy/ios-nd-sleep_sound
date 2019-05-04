//
//  DownloadService.swift
//  SleepSound
//
//  Created by mac on 5/1/19.
//  Copyright © 2019 mac. All rights reserved.
//

struct DownloadService {
    
    static let share = DownloadService()
    
    func downloadUrl(url: String, start: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        print("\(url) is downloading")
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Alamofire.download(
            url.encoded(),
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination)
            .downloadProgress(closure: { _ in })
            .response(completionHandler: { _ in
                print("\(url) is downloaded")
                completion?()
            })
    }
    
    func downloadUrls(urls: [String], start: (() -> Void)? = nil, startDownload: ((_ url: String) -> Void)? = nil, completion: (() -> Void)? = nil) {
        start?()
        let downloadGroup = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 0)
        let concurrentQueue = DispatchQueue(label: "queuename")
        concurrentQueue.async {
            for url in urls {
                downloadGroup.enter()
                startDownload?(url)
                self.downloadUrl(url: url,
                                 start: { },
                                 completion: {
                                    semaphore.signal()
                                    downloadGroup.leave()
                })
                semaphore.wait()
            }
        }
        downloadGroup.notify(queue: concurrentQueue) {
            print("All download are done")
            completion?()
        }
    }
}
