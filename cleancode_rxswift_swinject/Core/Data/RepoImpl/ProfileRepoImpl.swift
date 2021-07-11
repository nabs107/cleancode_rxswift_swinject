//
//  ProfileRepoImpl.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation
import RxSwift

final class ProfileRepoImpl: ProfileRepo {
    
    private final let network: Network<Profile>
    
    init(network: Network<Profile>) {
        self.network = network
    }
    
    func getProfile() -> Observable<Profile> {
        network.getItem(NetworkConfig.profileURL)
    }
    
}
