//
//  MealFoodController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor
import Fluent

struct MealFoodController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let mealFoods = routes.grouped("meal-foods")

        mealFoods.get(use: getAll)
        mealFoods.get(":mealFoodID", use: getById)

        let protected = mealFoods.grouped(JWTMiddleware())
        protected.post(use: create)
        protected.put(":mealFoodID", use: update)
        protected.delete(":mealFoodID", use: delete)
    }

    func getAll(req: Request) async throws -> [MealFoodDTO] {
        let list = try await MealFood.query(on: req.db).all()
        return list.map { MealFoodDTO(id: $0.id, mealID: $0.$meal.id, foodID: $0.$food.id, quantity: $0.quantity) }
    }

    func getById(req: Request) async throws -> MealFoodDTO {
        guard let idString = req.parameters.get("mealFoodID"),
              let uuid = UUID(uuidString: idString),
              let mealFood = try await MealFood.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        return MealFoodDTO(id: mealFood.id, mealID: mealFood.$meal.id, foodID: mealFood.$food.id, quantity: mealFood.quantity)
    }

    func create(req: Request) async throws -> MealFoodDTO {
        let dto = try req.content.decode(MealFoodCreateDTO.self)
        let mealFood = MealFood(mealID: dto.mealID, foodID: dto.foodID, quantity: dto.quantity)
        try await mealFood.save(on: req.db)
        return MealFoodDTO(id: mealFood.id, mealID: mealFood.$meal.id, foodID: mealFood.$food.id, quantity: mealFood.quantity)
    }

    func update(req: Request) async throws -> MealFoodDTO {
        guard let idString = req.parameters.get("mealFoodID"),
              let uuid = UUID(uuidString: idString),
              let mealFood = try await MealFood.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        let dto = try req.content.decode(MealFoodCreateDTO.self)
        mealFood.$meal.id = dto.mealID
        mealFood.$food.id = dto.foodID
        mealFood.quantity = dto.quantity
        try await mealFood.update(on: req.db)
        return MealFoodDTO(id: mealFood.id, mealID: mealFood.$meal.id, foodID: mealFood.$food.id, quantity: mealFood.quantity)
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let idString = req.parameters.get("mealFoodID"),
              let uuid = UUID(uuidString: idString),
              let mealFood = try await MealFood.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        try await mealFood.delete(on: req.db)
        return .noContent
    }
}
