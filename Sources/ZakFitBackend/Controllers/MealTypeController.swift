//
//  MealTypeController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor
import Fluent

struct MealTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {

        let mt = routes.grouped("meal-types")

        mt.get(use: getAll)
        mt.get(":mealTypeID", use: getById)

        let protected = mt.grouped(JWTMiddleware())
        protected.post(use: create)
        protected.put(":mealTypeID", use: update)
        protected.delete(":mealTypeID", use: delete)
    }

    func getAll(req: Request) async throws -> [MealTypeDTO] {
        let list = try await MealType.query(on: req.db).all()
        return list.map { MealTypeDTO(id: $0.id, name: $0.name) }
    }

    func getById(req: Request) async throws -> MealTypeDTO {
        guard let id = req.parameters.get("mealTypeID"),
              let uuid = UUID(uuidString: id),
              let mt = try await MealType.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        return MealTypeDTO(id: mt.id, name: mt.name)
    }

    func create(req: Request) async throws -> MealTypeDTO {
        let dto = try req.content.decode(MealTypeCreateDTO.self)
        let mt = MealType(name: dto.name)
        try await mt.save(on: req.db)
        return MealTypeDTO(id: mt.id, name: mt.name)
    }

    func update(req: Request) async throws -> MealTypeDTO {
        guard let id = req.parameters.get("mealTypeID"),
              let uuid = UUID(uuidString: id),
              let mt = try await MealType.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        let dto = try req.content.decode(MealTypeCreateDTO.self)
        mt.name = dto.name
        try await mt.update(on: req.db)
        return MealTypeDTO(id: mt.id, name: mt.name)
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("mealTypeID"),
              let uuid = UUID(uuidString: id),
              let mt = try await MealType.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        try await mt.delete(on: req.db)
        return .noContent
    }
}
