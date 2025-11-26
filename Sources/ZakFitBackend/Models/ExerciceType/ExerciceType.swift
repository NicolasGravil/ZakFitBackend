//
//  ExerciceType.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//
import Fluent
import Vapor

final class ExerciseType: Model, Content, @unchecked Sendable {
    static let schema = "exercise_types"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
