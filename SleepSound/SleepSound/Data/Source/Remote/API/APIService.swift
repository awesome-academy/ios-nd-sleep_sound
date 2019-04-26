//
//  APIService.swift
//  SleepSound
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

struct APIService {
    
    static let share = APIService()
    
    private var alamofireManager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager.adapter = CustomRequestAdapter()
    }
    
    func request<T: Mappable>(input: BaseRequest, completion: @escaping (_ value: T?, _ error: BaseError?) -> Void) {
        print(input)
        alamofireManager.request(input.url,
                                 method: input.requestType,
                                 parameters: input.parameters,
                                 encoding: input.encoding)
        .validate(statusCode: 200..<500)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        print("👍 [\(statusCode)] " + input.url)
                        //                            print(response)
                        let object = Mapper<T>().map(JSONObject: value)
                        completion(object, nil)
                    } else {
                        print("❌ [\(statusCode)] " + input.url)
                        if let error = Mapper<ErrorResponse>().map(JSONObject: value) {
                            print(error)
                            completion(nil, BaseError.apiFailure(error: error))
                        } else {
                            completion(nil, BaseError.httpError(httpCode: statusCode))
                        }
                    }
                } else {
                    completion(nil, BaseError.unexpectedError)
                }
            case .failure(let error):
                completion(nil, error as? BaseError)
            }
        }
    }
}
