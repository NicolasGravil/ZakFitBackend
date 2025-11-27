//
//  ExerciseTypeController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 27/11/2025.
//

import Vapor
import Fluent

struct ExerciseTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let types = routes.grouped("exercise-types")

        // Public
        types.get(use: getAll)
        types.get(":typeID", use: getById)

        // Protected
        let protected = types.grouped(JWTMiddleware())
        protected.post(use: create)
        protected.put(":typeID", use: update)
        protected.delete(":typeID", use: delete)
    }

    func getAll(req: Request) async throws -> [ExerciseTypeDTO] {
        let list = try await ExerciseType.query(on: req.db).all()
        return list.map { ExerciseTypeDTO(id: $0.id, name: $0.name) }
    }

    func getById(req: Request) async throws -> ExerciseTypeDTO {
        guard let idString = req.parameters.get("typeID"),
              let uuid = UUID(uuidString: idString),
              let type = try await ExerciseType.find(uuid, on: req.db)
        else { throw Abort(.notFound) }

        return ExerciseTypeDTO(id: type.id, name: type.name)
    }

    func create(req: Request) async throws -> ExerciseTypeDTO {
        let dto = try req.content.decode(ExerciseTypeCreateDTO.self)

        let type = ExerciseType(name: dto.name)
        try await type.save(on: req.db)

        return ExerciseTypeDTO(id: type.id, name: type.name)
    }

    func update(req: Request) async throws -> ExerciseTypeDTO {
        guard let idString = req.parameters.get("typeID"),
              let uuid = UUID(uuidString: idString),
              let type = try await ExerciseType.find(uuid, on: req.db)
        else { throw Abort(.notFound) }

        let dto = try req.content.decode(ExerciseTypeCreateDTO.self)
        type.name = dto.name

        try await type.update(on: req.db)
        return ExerciseTypeDTO(id: type.id, name: type.name)
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let idString = req.parameters.get("typeID"),
              let uuid = UUID(uuidString: idString),
              let type = try await ExerciseType.find(uuid, on: req.db)
        else { throw Abort(.notFound) }

        try await type.delete(on: req.db)
        return .noContent
    }
}
