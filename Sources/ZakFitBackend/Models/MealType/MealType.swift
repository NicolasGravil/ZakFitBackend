//
//  MealType.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//
import Vapor
import Fluent

final class MealType: Model, Content, @unchecked Sendable {
    static let schema = "mealType"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    
    init() {}
    init(id: UUID? = nil, name: String) { self.id = id; self.name = name }
}

