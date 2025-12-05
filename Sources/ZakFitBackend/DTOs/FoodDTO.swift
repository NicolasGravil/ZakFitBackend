//
//  FoodDTO.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 03/12/2025.
//

import Vapor
import Fluent

struct FoodDTO: Content {
    let id: UUID?
    let userID: UUID?
    let name: String
    let caloriesPer100g: Int
    let proteinsPer100g: Double
    let carbsPer100g: Double
    let fatsPer100g: Double
}

