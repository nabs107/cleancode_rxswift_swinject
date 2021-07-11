//
//  ProfileUseCase.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation
import RxSwift

final class ProfileUseCase {
    
    private final let profileRepo: ProfileRepo
    private final let nationalityRepo: NationalityRepo
    
    init(profileRepo: ProfileRepo, nationalityRepo: NationalityRepo) {
        self.profileRepo = profileRepo
        self.nationalityRepo = nationalityRepo
    }
    
    func getProfile() -> Observable<Profile> {
        Observable.zip(profileRepo.getProfile(), nationalityRepo.getNationalities()).map { (profile, nationalityAPI) -> Profile in
            var finalProfileWithNationalityName = profile
            
            var nationality: Nationality?
            
            nationalityAPI.data?.forEach({ data in
                if data.id == profile.nationality {
                    nationality = data
                }
            })
            
            finalProfileWithNationalityName.nationalityName = nationality?.nationality
            return finalProfileWithNationalityName
        }
    }
    
}
