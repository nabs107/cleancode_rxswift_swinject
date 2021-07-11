//
//  NationalityAPI.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation

struct NationalityAPI: Codable {
    public var data: [Nationality]?
}

struct Nationality: Codable {
    public var id: Int?
    public var nationality: String?
    public var createdAt: String?
    public var updatedAt: String?
}
