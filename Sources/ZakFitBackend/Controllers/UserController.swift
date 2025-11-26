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
        
        // Création d'utilisateur
        users.post("register", use: register)
        
        // Login
        users.post("login", use: login)
        
        // Routes protégées
        let protected = users.grouped(JWTMiddleware())
        protected.get("me", use: me)
    }

    // Création
    func register(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        
        // Hash du mot de passe avant de sauvegarder
        user.password = try Bcrypt.hash(user.password)
        
        return user.save(on: req.db).map { user }
    }

    // Connexion
    struct LoginRequest: Content {
        let email: String
        let password: String
    }

    struct LoginResponse: Content {
        let token: String
    }

    func login(req: Request) throws -> EventLoopFuture<LoginResponse> {
        let login = try req.content.decode(LoginRequest.self)
        return User.query(on: req.db)
            .filter(\.$email == login.email)
            .first()
            .flatMapThrowing { user in
                guard let user = user, try Bcrypt.verify(login.password, created: user.password) else {
                    throw Abort(.unauthorized, reason: "Invalid email or password")
                }
                let payload = UserPayload(id: user.id!) // Utiliser l'UUID réel du user
                let token = try JWTSigner.hs256(key: "OnePieceIsReal").sign(payload)
                return LoginResponse(token: token)
            }
        }

    }

    // Exemple route protégée
    func me(req: Request) throws -> String {
        let payload = try req.auth.require(UserPayload.self)
        return "User id: \(payload.id)"
    }

