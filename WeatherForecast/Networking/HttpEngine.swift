//
//  HttpEngine.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 18/06/2021.
//

import RxSwift
import Foundation

protocol HttpEngineInterface {
    func fetch(from request: URLRequest?) -> Observable<Data>
}

class HttpEngine: HttpEngineInterface {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetch(from request: URLRequest?) -> Observable<Data> {
        guard let request = request else {
            return Observable.error(NSError())
        }
        return Observable<Data>.create { [weak self] observer -> Disposable in
            let task = self?.dataTask(with: request, observer: observer)
            task?.resume()
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    private func dataTask(with request: URLRequest, observer: AnyObserver<Data>) -> URLSessionDataTask {
        urlSession.dataTask(with: request, completionHandler: { data, _, error -> Void in
            if let error = error {
                DispatchQueue.main.async {
                    observer.onError(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                observer.onNext(data ?? Data())
                observer.onCompleted()
            }
        })
    }
}
