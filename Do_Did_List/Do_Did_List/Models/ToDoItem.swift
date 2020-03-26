//
//  DB.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/02/27.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    
    @objc dynamic var id: String = UUID().uuidString // 고유 아이디
    
    @objc dynamic var title: String = "" // 매인 타이틀
    @objc dynamic var imageTag: String = "" // 이미지 태그
    
    @objc dynamic var timestamp: Date = Date() // 날짜, 시간
    @objc dynamic var importance: Double = 0.0 // 0.0 ~ 3.0
    @objc dynamic var content: String = "" // 내용
    
    @objc dynamic var isDone: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(title: String, imageTag: String, timestamp: Date, importance: Double, content: String, isDone: Bool) {
        self.init()
        
        self.title = title
        self.imageTag = imageTag
        self.timestamp = timestamp
        self.importance = importance
        self.content = content
        self.isDone = isDone
    }
}
