//
//  Food.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Fluent
import Vapor

final class Food: Model, Content, @unchecked Sendable {
    static let schema = "foods"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "calories_per_100g") var caloriesPer100g: Int
    @Field(key: "proteins_per_100g") var proteinsPer100g: Double
    @Field(key: "carbs_per_100g") var carbsPer100g: Double
    @Field(key: "fats_per_100g") var fatsPer100g: Double
    @Field(key: "category") var category: String?
    @Field(key: "is_custom") var isCustom: Bool
    @OptionalParent(key: "user_id") var creator: User?
    
    init() {}
}

