//
//  NationalityUseCase.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation
import RxSwift

final class NationalityUseCase {
    
    private final let nationalityRepo: NationalityRepo
    
    init(nationalityRepo: NationalityRepo) {
        self.nationalityRepo = nationalityRepo
    }
    
    func getNationalities() -> Observable<NationalityAPI> {
        nationalityRepo.getNationalities()
    }
    
}
