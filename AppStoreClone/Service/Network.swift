//
//  Network.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

final class Network<T: Decodable> {

    private let endPoint: String
    private let scheduler: ConcurrentDispatchQueueScheduler

    init(_ endPoint: String) {
        self.endPoint = endPoint
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
    }

    func getItem(_ query: String) -> Observable<T?> {
        let absolutePath = endPoint + query
        return RxAlamofire
            .data(.get, absolutePath)
            .observeOn(scheduler)
            .map({ data -> T? in
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch let error {
                    print(error)
                    return nil
                }
            })
    }
    
}
