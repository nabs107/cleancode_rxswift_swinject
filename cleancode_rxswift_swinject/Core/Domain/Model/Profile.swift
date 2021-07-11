//
//  Profile.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation

public struct Profile: Codable {
    public let id: Int?
    public let name: String?
    public let email: String?
    public let username: String?
    public let gender: String?
    public let dob: String?
    public let phoneNumber: String?
    public let nationality: Int?
    public var nationalityName: String?
}
