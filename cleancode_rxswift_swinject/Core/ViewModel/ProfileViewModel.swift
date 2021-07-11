//
//  ProfileViewModel.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation
import RxSwift

final class ProfileViewModel {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    public let profile: PublishSubject<Profile> = .init()
    
    private final let profileUseCase: ProfileUseCase
    
    init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
    }
    
    func getProfile() {
        profileUseCase.getProfile()
            .subscribe(onNext: {
                self.profile.onNext($0)
            }, onError: {
                print($0.localizedDescription)
            }
        ).disposed(by: disposeBag)
    }
    
}
