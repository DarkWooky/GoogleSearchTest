//
//  SearchModel.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 19.12.21.
//

import Foundation

struct SearchResponse: Codable {
    let kind : String?
    let items : [Item]
}

struct Item : Codable {
    let title : String?
    let link : String?
    let snippet : String?
}
