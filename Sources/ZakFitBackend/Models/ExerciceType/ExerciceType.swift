//
//  ExerciceType.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//
import Fluent
import Vapor

final class ExerciseType: Model, Content, @unchecked Sendable {
    static let schema = "exerciseType"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "type") var type: String
    
    init() {}
    
    init(id: UUID? = nil, type: String) {
        self.id = id
        self.type = type
    }
}
