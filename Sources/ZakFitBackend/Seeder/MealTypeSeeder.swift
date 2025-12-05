//
//  MealTypeSeeder.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 04/12/2025.
//

import Vapor
import Fluent

struct MealTypeSeeder {
    static func seed(_ app: Application) async throws {

        // Vérifie si la table est vide
        let count = try await MealType.query(on: app.db).count()
        if count > 0 {
            print("MealType déjà rempli, aucun seed nécessaire.")
            return
        }

        print(" Seeding MealTypes...")

        let types = [
            MealType(name: "Petit déjeuner"),
            MealType(name: "Déjeuner"),
            MealType(name: "Dîner"),
            MealType(name: "Snack")
        ]

        for type in types {
            try await type.save(on: app.db)
        }

        print("MealTypes ajoutés avec succès !")
    }
}
