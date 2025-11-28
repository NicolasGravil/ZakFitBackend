//
//  FoodController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor
import Fluent

struct FoodController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let foods = routes.grouped("food")

        // Public routes
        foods.get(use: getAll)
        foods.get(":foodID", use: getById)
        

        // Protected routes
        let protected = foods.grouped(JWTMiddleware())
        protected.post(use: create)
        protected.put(":foodID", use: update)
        protected.delete(":foodID", use: delete)
    }

    // GET /foods
    func getAll(req: Request) async throws -> [Food] {
        try await Food.query(on: req.db).all()
    }

    // GET /foods/:foodID
    func getById(req: Request) async throws -> Food {
        guard let idString = req.parameters.get("foodID"),
              let uuid = UUID(uuidString: idString),
              let food = try await Food.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        return food
    }

    // POST /foods
    func create(req: Request) async throws -> Food {
        print("POST /foods reçu !")

        // Décoder le DTO envoyé dans le body
        let dto = try req.content.decode(FoodCreateDTO.self)

        // Créer l'objet Food avec l'init par défaut
        let food = Food()
        food.name = dto.name
        food.caloriesPer100g = dto.caloriesPer100g
        food.proteinsPer100g = dto.proteinsPer100g
        food.carbsPer100g = dto.carbsPer100g
        food.fatsPer100g = dto.fatsPer100g
        food.category = dto.category
        food.isCustom = dto.isCustom

        // Assigner le créateur si fourni
        if let creatorID = dto.creatorID {
            food.$creator.id = creatorID
        }

        // Sauvegarder dans la base de données
        try await food.save(on: req.db)

        return food
    }


    // PUT /foods/:foodID
    func update(req: Request) async throws -> Food {
        guard let idString = req.parameters.get("foodID"),
              let uuid = UUID(uuidString: idString),
              let food = try await Food.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        let dto = try req.content.decode(FoodCreateDTO.self)
        food.name = dto.name
        food.caloriesPer100g = dto.caloriesPer100g
        food.proteinsPer100g = dto.proteinsPer100g
        food.carbsPer100g = dto.carbsPer100g
        food.fatsPer100g = dto.fatsPer100g
        food.category = dto.category
        food.isCustom = dto.isCustom
        food.$creator.id = dto.creatorID

        try await food.update(on: req.db)
        return food
    }

    // DELETE /foods/:foodID
    func delete(req: Request) async throws -> HTTPStatus {
        guard let idString = req.parameters.get("foodID"),
              let uuid = UUID(uuidString: idString),
              let food = try await Food.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        try await food.delete(on: req.db)
        return .noContent
    }
}
