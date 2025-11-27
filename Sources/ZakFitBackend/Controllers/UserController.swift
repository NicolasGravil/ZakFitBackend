//
//  UserController.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 26/11/2025.
//

import Vapor
import Fluent
import JWT

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        // Routes publiques
        users.post("register", use: create)
        users.post("login", use: login)
        
        // Routes protégées par JWT
        let protected = users.grouped(JWTMiddleware())
        protected.get("profile", use: profile)
        protected.put(":userID", use: update)
        protected.patch(":userID", use: patch)
        protected.delete(":userID", use: delete)
        
        // Routes admin (optionnel)
        users.get(use: getAll)
        users.get(":userID", use: getById)
    }
    
    struct LoginResponse: Content {
        let token: String
        let user: UserDTO
    }
    
    // POST /users/login
    @Sendable
    func login(req: Request) async throws -> LoginResponse {
        let loginData = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == loginData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Email ou mot de passe incorrect")
        }
        
        guard try Bcrypt.verify(loginData.password, created: user.password) else {
            throw Abort(.unauthorized, reason: "Email ou mot de passe incorrect")
        }
        
        let payload = UserPayload(id: user.id!)
        let token = try req.jwt.sign(payload)
        
        return LoginResponse(token: token, user: user.toDTO())
    }
    
    // GET /users/profile (Route protégée)
    @Sendable
    func profile(req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur non trouvé")
        }
        return user.toDTO()
    }
    
    // POST /users/register
    @Sendable
    func create(req: Request) async throws -> UserDTO {
        let userDTO = try req.content.decode(UserCreateDTO.self)
        
        // Vérifier si l'email existe déjà
        if try await User.query(on: req.db)
            .filter(\.$email == userDTO.email)
            .first() != nil {
            throw Abort(.conflict, reason: "Cet email est déjà utilisé")
        }
        
        // Parser la date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let birthDate = dateFormatter.date(from: userDTO.birthDate) else {
            throw Abort(.badRequest, reason: "Format de date invalide. Utilisez yyyy-MM-dd")
        }
        
        let user = User(
            name: userDTO.name,
            lastName: userDTO.lastName,
            email: userDTO.email,
            password: try Bcrypt.hash(userDTO.password),
            height: userDTO.height,
            weight: userDTO.weight,
            birthDate: birthDate,
            goals: userDTO.goals,
            diet: userDTO.diet,
            gender: userDTO.gender
        )
        
        try await user.save(on: req.db)
        return user.toDTO()
    }
    
    // GET /users
    @Sendable
    func getAll(req: Request) async throws -> [UserDTO] {
        let users = try await User.query(on: req.db).all()
        return users.map { $0.toDTO() }
    }
    
    // GET /users/:userID
    @Sendable
    func getById(req: Request) async throws -> UserDTO {
        guard let userIDString = req.parameters.get("userID"),
              let userID = UUID(uuidString: userIDString),
              let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur non trouvé")
        }
        return user.toDTO()
    }
    
    // PUT /users/:userID
    @Sendable
    func update(req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let userIDString = req.parameters.get("userID"),
              let userID = UUID(uuidString: userIDString),
              userID == payload.id else {
            throw Abort(.forbidden, reason: "Vous ne pouvez modifier que votre propre profil")
        }
        
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur non trouvé")
        }
        
        let dto = try req.content.decode(UserCreateDTO.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let birthDate = dateFormatter.date(from: dto.birthDate) else {
            throw Abort(.badRequest, reason: "Format de date invalide")
        }
        
        user.name = dto.name
        user.lastName = dto.lastName
        user.email = dto.email
        user.password = try Bcrypt.hash(dto.password)
        user.height = dto.height
        user.weight = dto.weight
        user.birthDate = birthDate
        user.goals = dto.goals
        user.diet = dto.diet
        user.gender = dto.gender
        
        try await user.update(on: req.db)
        return user.toDTO()
    }
    
    // PATCH /users/:userID
    @Sendable
    func patch(req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let userIDString = req.parameters.get("userID"),
              let userID = UUID(uuidString: userIDString),
              userID == payload.id else {
            throw Abort(.forbidden, reason: "Vous ne pouvez modifier que votre propre profil")
        }
        
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur non trouvé")
        }
        
        let dto = try req.content.decode(PartialUserDTO.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let name = dto.name { user.name = name }
        if let lastName = dto.lastName { user.lastName = lastName }
        if let email = dto.email { user.email = email }
        if let password = dto.password { user.password = try Bcrypt.hash(password) }
        if let height = dto.height { user.height = height }
        if let weight = dto.weight { user.weight = weight }
        if let goals = dto.goals { user.goals = goals }
        if let diet = dto.diet { user.diet = diet }
        if let gender = dto.gender { user.gender = gender }
        if let birthDateStr = dto.birthDate,
           let birthDate = dateFormatter.date(from: birthDateStr) {
            user.birthDate = birthDate
        }
        
        try await user.update(on: req.db)
        return user.toDTO()
    }
    
    // DELETE /users/:userID
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let userIDString = req.parameters.get("userID"),
              let userID = UUID(uuidString: userIDString),
              userID == payload.id else {
            throw Abort(.forbidden, reason: "Vous ne pouvez supprimer que votre propre compte")
        }
        
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur non trouvé")
        }
        
        try await user.delete(on: req.db)
        return .noContent
    }
}
