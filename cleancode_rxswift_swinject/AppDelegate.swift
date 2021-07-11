//
//  AppDelegate.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let container = Container() { container in
        container.register(Network.self) { _ in Network<NationalityAPI>.init() }
        container.register(Network.self) { _ in Network<Profile>.init() }
        
        // Nationality
        container.register(NationalityRepo.self) { resolver in
            let nationalityRepo = NationalityRepoImpl(network: resolver.resolve(Network<NationalityAPI>.self)!)
            return nationalityRepo
        }
        
        container.register(NationalityUseCase.self) { resolver in
            NationalityUseCase(nationalityRepo: resolver.resolve(NationalityRepo.self)!)
        }
        
        container.register(NationalityViewModel.self) { resolver in
            NationalityViewModel(nationalityUseCase: resolver.resolve(NationalityUseCase.self)!)
        }
        
        // Profile
        container.register(ProfileRepo.self) { resolver in
            ProfileRepoImpl(network: resolver.resolve(Network<Profile>.self)!)
        }
        
        container.register(ProfileUseCase.self) { resolver in
            ProfileUseCase(profileRepo: resolver.resolve(ProfileRepo.self)!, nationalityRepo: resolver.resolve(NationalityRepo.self)!)
        }
        
        container.register(ProfileViewModel.self) { resolver in
            ProfileViewModel(profileUseCase: resolver.resolve(ProfileUseCase.self)!)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

