//
//  Food.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent
import Vapor

final class Food: Model, Content, @unchecked Sendable {
    static let schema = "food"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "calories") var caloriesPer100g: Int
    @Field(key: "proteine") var proteinsPer100g: Double
    @Field(key: "glucide") var carbsPer100g: Double
    @Field(key: "lipide") var fatsPer100g: Double
    @Field(key: "category") var category: String?
    @Field(key: "isCustom") var isCustom: Bool
    @OptionalParent(key: "user_id") var creator: User?
    
    init() {}
}
