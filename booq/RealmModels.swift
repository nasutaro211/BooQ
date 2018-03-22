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
    @objc dynamic var nextEmergenceDay = Date()
    @objc dynamic var consecutiveCorrectTimes = 0
    //この問題が登録された本
    let book = LinkingObjects(fromType: Book.self, property: "questions").first
    //答えs
    let answers = List<Answer>()
    
}

class Answer: Object {
    //primaryKeyの設定
    override static func primaryKey() -> String?{
        return "answerID"
    }
    //カラムの設定
    @objc dynamic var answerID = 0
    @objc dynamic var answerStr = ""
    //この答えが登録された問い
    let question = LinkingObjects(fromType: Question.self, property: "answers").first
}

