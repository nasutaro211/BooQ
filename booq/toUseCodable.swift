//
//  toUseCodable.swift
//  
//
//  Created by 中田　優樹 on 2018/03/20.
//

import Foundation

struct ResponseData:Codable {
    let totalItems:Int
    let items:[Item]
}

struct Item:Codable{
    let volumeInfo:VolumeInfo
}

struct VolumeInfo:Codable {
    let title:String
    let authors:[String]
    let publishedDate:String
    let industryIdentifiers:[IndustryIdentifier]
    let imageLinks:[String:String]
}

struct IndustryIdentifier:Codable {
    let type:String
    let identifier:String
}
