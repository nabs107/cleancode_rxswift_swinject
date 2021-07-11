//
//  NationalityRepoImpl.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation
import RxSwift

final class NationalityRepoImpl: NationalityRepo {
    
    private final let network: Network<NationalityAPI>
    
    init(network: Network<NationalityAPI>) {
        self.network = network
    }
    
    func getNationalities() -> Observable<NationalityAPI> {
        network.getItem(NetworkConfig.nationalityURL)
    }
    
}
