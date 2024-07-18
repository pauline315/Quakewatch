//
//  EarthquakeViewModel.swift
//  quakealert
//
//  Created by EMTECH MAC on 18/07/2024.
//

import Foundation
import RxSwift
import RxCocoa

class EarthquakeViewModel {
  let apiManager: APIManager
  let disposeBag = DisposeBag()
  
  // Input
  let fetchAPI = PublishSubject<Void>()
  
  // Output
  let data: BehaviorRelay<[Earthquake]> = BehaviorRelay(value: [])
  let error: PublishSubject<String> = PublishSubject()
  
  init(apiManager: APIManager) {
      self.apiManager = apiManager
      setupBindings()
  }
  
  private func setupBindings() {
      fetchAPI
          .flatMap { self.apiManager.fetchAPI() }
          .subscribe(onNext: { [weak self] earthquakes in
              self?.data.accept(earthquakes)
          }, onError: { [weak self] error in
              self?.error.onNext(error.localizedDescription)
          })
          .disposed(by: disposeBag)
  }
}
