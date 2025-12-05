//
//  FoodCreateDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor

struct FoodCreateDTO: Content {
    let name: String
    let caloriesPer100g: Int
    let proteinsPer100g: Double
    let carbsPer100g: Double
    let fatsPer100g: Double
    let category: String?
    let isCustom: Bool
    let creatorID: UUID?
}
//struct FoodCreateDTO: Content {
//    let userID: UUID?
//    let name: String
//    let calories: Int
//    let proteins: Double
//    let carbs: Double
//    let fats: Double
//}
