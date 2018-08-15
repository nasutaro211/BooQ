//
//  RealmModels.swift
//  
//
//  Created by 中田　優樹 on 2018/03/18.
//

import Foundation
import RealmSwift

class Book: Object {
    //primaryKeyの設定
    override static func primaryKey() -> String? {
        return "ISBN"
    }
    //カラムの設定
    @objc dynamic var ISBN = "1111111111111"
    @objc dynamic var imageLink = "http://illustrain.com/img/work/2016/illustrain10-hon01.png"
    @objc dynamic var title = "タイトルはありません"
    @objc dynamic var authors = ""
//    @objc dynamic var imageData:Data? ver.0,ver.1
//    @objc dynamic var imageFileURLStr = ""//ver.2
    //問題s
    let questions = List<Question>()
}

class Question: Object {
    //primaryKeyの設定
    override static func primaryKey() -> String?{
        return "questionID"
    }
    //カラムの設定
    @objc dynamic var questionID = ""
    @objc dynamic var questionStr = ""
    @objc dynamic var registeredDay = Date()
    @objc dynamic var nextEmergenceDay = 0//"yyyyMMdd"→ver.2で変更
    @objc dynamic var numInBook = "" //ver.1~
    @objc dynamic var consecutiveCorrectTimes = 0
    //答えs
    let answers = List<Answer>()
    //この問題が登録された本
    let books = LinkingObjects(fromType: Book.self, property: "questions")
}

class Answer: Object {
    //primaryKeyの設定
    override static func primaryKey() -> String?{
        return "answerID"
    }
    //カラムの設定
    @objc dynamic var answerID = ""
    @objc dynamic var answerStr = ""
    //この答えが登録された問い
    let question = LinkingObjects(fromType: Question.self, property: "answers").first
}

