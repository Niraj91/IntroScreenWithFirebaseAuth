//
//  AddressResponse.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import Foundation

struct AddressResponse: Codable {
    let postcode: String?
    let latitude: Double?
    let longitude: Double?
    let addresses: [Addresses]?
}

struct Addresses: Codable {
    let formatted_address: [String]?
    let thoroughfare: String?
    let building_name: String?
    let sub_building_name: String?
    let sub_building_number: String?
    let building_number: String?
    let line_1: String?
    let line_2: String?
    let line_3: String?
    let line_4: String?
    let locality: String?
    let town_or_city: String?
    let county: String?
    let district: String?
    let country: String?
}
