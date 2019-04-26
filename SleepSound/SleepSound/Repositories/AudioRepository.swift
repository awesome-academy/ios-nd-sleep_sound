//
//  AudioRepository.swift
//  SleepSound
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

protocol AudioRepository {
    func fetchAudio(page: Int, completion: @escaping (BaseResult<Data>) -> Void)
}

final class AudioRepositoryImpl: AudioRepository {
    
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func fetchAudio(page: Int, completion: @escaping (BaseResult<Data>) -> Void) {
        let input = AudiosRequest()
        
        api?.request(input: input, completion: { (object: Data?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        })
    }
}
