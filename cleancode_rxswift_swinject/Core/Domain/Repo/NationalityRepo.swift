//
//  NationalityRepo.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation
import RxSwift

protocol NationalityRepo {
    func getNationalities() -> Observable<NationalityAPI>
}
