//
//  ExerciseController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 28/11/2025.
//

import Vapor
import Fluent

struct ExerciseController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let exercises = routes.grouped("exercises")

        exercises.get(use: getAll)
        exercises.get(":exerciseID", use: getById)

        let protected = exercises.grouped(JWTMiddleware())
        protected.post(use: create)
        protected.put(":exerciseID", use: update)
        protected.delete(":exerciseID", use: delete)
    }

    func getAll(req: Request) async throws -> [ExerciseDTO] {
        let list = try await Exercise.query(on: req.db).all()
        return list.map { ExerciseDTO(
            id: $0.id,
            userID: $0.$user.id,
            typeID: $0.$type.id,
            name: $0.name,
            duration: $0.duration,
            calories: $0.calories,
            date: $0.date
        )}
    }

    func getById(req: Request) async throws -> ExerciseDTO {
        guard let idString = req.parameters.get("exerciseID"),
              let uuid = UUID(uuidString: idString),
              let exercise = try await Exercise.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        return ExerciseDTO(
            id: exercise.id,
            userID: exercise.$user.id,
            typeID: exercise.$type.id,
            name: exercise.name,
            duration: exercise.duration,
            calories: exercise.calories,
            date: exercise.date
        )
    }

    func create(req: Request) async throws -> ExerciseDTO {
        let dto = try req.content.decode(ExerciseCreateDTO.self)
        let exercise = Exercise(
            userID: dto.userID,
            typeID: dto.typeID,
            name: dto.name,
            duration: dto.duration,
            calories: dto.calories,
            date: dto.date
        )
        try await exercise.save(on: req.db)
        return ExerciseDTO(
            id: exercise.id,
            userID: exercise.$user.id,
            typeID: exercise.$type.id,
            name: exercise.name,
            duration: exercise.duration,
            calories: exercise.calories,
            date: exercise.date
        )
    }

    func update(req: Request) async throws -> ExerciseDTO {
        guard let idString = req.parameters.get("exerciseID"),
              let uuid = UUID(uuidString: idString),
              let exercise = try await Exercise.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        let dto = try req.content.decode(ExerciseCreateDTO.self)
        exercise.$user.id = dto.userID
        exercise.$type.id = dto.typeID
        exercise.name = dto.name
        exercise.duration = dto.duration
        exercise.calories = dto.calories
        exercise.date = dto.date
        try await exercise.update(on: req.db)
        return ExerciseDTO(
            id: exercise.id,
            userID: exercise.$user.id,
            typeID: exercise.$type.id,
            name: exercise.name,
            duration: exercise.duration,
            calories: exercise.calories,
            date: exercise.date
        )
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let idString = req.parameters.get("exerciseID"),
              let uuid = UUID(uuidString: idString),
              let exercise = try await Exercise.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        try await exercise.delete(on: req.db)
        return .noContent
    }
}
