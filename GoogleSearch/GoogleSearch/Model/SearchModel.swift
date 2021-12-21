//
//  SearchModel.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 19.12.21.
//

import Foundation

struct ResponseResult: Codable {
    let items : [Item]
}

struct Item : Codable {
    let title : String?
    let displayLink : String?
    let snippet : String?
}
