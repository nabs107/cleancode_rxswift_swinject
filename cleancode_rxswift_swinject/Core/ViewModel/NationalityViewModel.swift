//
//  NationalityViewModel.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation
import RxSwift

final class NationalityViewModel {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private final let nationalityUseCase: NationalityUseCase
    
    init(nationalityUseCase: NationalityUseCase) {
        self.nationalityUseCase = nationalityUseCase
    }
    
    func getNationalities() {
        nationalityUseCase.getNationalities()
            .subscribe(onNext: {
                print($0.data?.count ?? 0)
            }, onError: {
                print($0.localizedDescription)
            }
        ).disposed(by: disposeBag)
    }
    
}
