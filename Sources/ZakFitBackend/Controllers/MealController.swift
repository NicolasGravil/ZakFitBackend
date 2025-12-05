//
//  MealController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor
import Fluent

struct MealController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let meals = routes.grouped("meals")

        meals.get(use: getAll)
        meals.get(":mealID", use: getById)
        
        meals.get("full", use: getFullMeals) // correspond à GET /meals/full

        let protected = meals.grouped(JWTMiddleware())
        protected.post(use: create)
        protected.put(":mealID", use: update)
        protected.delete(":mealID", use: delete)
        
    }

    func getAll(req: Request) async throws -> [MealDTO] {
        let list = try await Meal.query(on: req.db).all()
        return list.map { MealDTO(id: $0.id, userID: $0.$user.id, mealTypeID: $0.$mealType.id, date: $0.date) }
    }

    func getById(req: Request) async throws -> MealDTO {
        guard let idString = req.parameters.get("mealID"),
              let uuid = UUID(uuidString: idString),
              let meal = try await Meal.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        return MealDTO(id: meal.id, userID: meal.$user.id, mealTypeID: meal.$mealType.id, date: meal.date)
    }

    func create(req: Request) async throws -> MealDTO {
        let dto = try req.content.decode(MealCreateDTO.self)
        let meal = Meal(userID: dto.userID, mealTypeID: dto.mealTypeID, date: dto.date)
        try await meal.save(on: req.db)
        return MealDTO(id: meal.id, userID: meal.$user.id, mealTypeID: meal.$mealType.id, date: meal.date)
    }

    func update(req: Request) async throws -> MealDTO {
        guard let idString = req.parameters.get("mealID"),
              let uuid = UUID(uuidString: idString),
              let meal = try await Meal.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        let dto = try req.content.decode(MealCreateDTO.self)
        meal.$user.id = dto.userID
        meal.$mealType.id = dto.mealTypeID
        meal.date = dto.date
        try await meal.update(on: req.db)
        return MealDTO(id: meal.id, userID: meal.$user.id, mealTypeID: meal.$mealType.id, date: meal.date)
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let idString = req.parameters.get("mealID"),
              let uuid = UUID(uuidString: idString),
              let meal = try await Meal.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        try await meal.delete(on: req.db)
        return .noContent
    }
    
    func getFullMeals(req: Request) async throws -> [MealFullDTO] {
        // Récupérer tous les repas
        let meals = try await Meal.query(on: req.db).all()
        
        // Récupérer tous les types de repas
        let mealTypes = try await MealType.query(on: req.db).all()
        
        // Construire le tableau complet
        var fullMeals: [MealFullDTO] = []
        
        for meal in meals {
            guard let mealType = mealTypes.first(where: { $0.id == meal.$mealType.id }) else { continue }
            
            let mealDTO = MealFullDTO(
                id: meal.id!,
                userID: meal.$user.id,  // pas meal.userID
                mealType: MealTypeDTO(id: mealType.id!, name: mealType.name),
                date: meal.date,
                foods: [] // tu peux remplir avec les MealFoodDTO si besoin
            )
            
            fullMeals.append(mealDTO)
        }
        
        return fullMeals
    }
    



}
