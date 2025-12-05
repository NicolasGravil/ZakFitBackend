//
//  FoodSeeder.swift
//  ZakFitBackend
//
//  Created by Apprenant156 on 04/12/2025.
//
import Vapor
import Fluent

struct FoodSeeder {
    static func seed(on database: any Database) async throws {
        // Ne rien faire si la table contient déjà des aliments
        let existing = try await Food.query(on: database).count()
        if existing > 0 {
            appLogger("FoodSeeder", "skip - foods already exist")
            return
        }

        appLogger("FoodSeeder", "seeding default foods...")

        // Créer les aliments en utilisant l'init() de ton modèle Food
        func makeFood(
            id: UUID? = nil,
            name: String,
            calories: Int,
            proteins: Double,
            carbs: Double,
            fats: Double,
            category: String? = nil,
            isCustom: Bool = false
        ) -> Food {
            let f = Food()
            f.id = id
            f.name = name
            f.caloriesPer100g = calories
            f.proteinsPer100g = proteins
            f.carbsPer100g = carbs
            f.fatsPer100g = fats
            f.category = category
            f.isCustom = isCustom
            // creator (OptionalParent) : on le laisse nil pour les seeds
            return f
        }

        let seeds: [Food] = [
            makeFood(name: "Pomme", calories: 52, proteins: 0.3, carbs: 14, fats: 0.2, category: "Fruits"),
            makeFood(name: "Banane", calories: 89, proteins: 1.1, carbs: 23, fats: 0.3, category: "Fruits"),
            makeFood(name: "Poulet (cuit)", calories: 165, proteins: 31, carbs: 0, fats: 3.6, category: "Viandes"),
            makeFood(name: "Riz blanc (cuit)", calories: 130, proteins: 2.4, carbs: 28, fats: 0.3, category: "Féculents"),
            makeFood(name: "Pâtes (cuites)", calories: 131, proteins: 5, carbs: 25, fats: 1.1, category: "Féculents"),
            makeFood(name: "Œuf (entier)", calories: 155, proteins: 13, carbs: 1.1, fats: 11, category: "Produits laitiers / Œufs"),
            makeFood(name: "Amande", calories: 579, proteins: 21, carbs: 22, fats: 50, category: "Fruits à coque"),
            makeFood(name: "Brocoli (cuit)", calories: 35, proteins: 2.4, carbs: 7, fats: 0.4, category: "Légumes"),
            makeFood(name: "Yaourt nature", calories: 59, proteins: 10, carbs: 3.6, fats: 0.4, category: "Produits laitiers"),
            makeFood(name: "Saumon (cuit)", calories: 208, proteins: 20, carbs: 0, fats: 13, category: "Poissons")
        ]

        for food in seeds {
            try await food.create(on: database)
        }

        appLogger("FoodSeeder", "✅ default foods created")
    }

    // Utilitaire de log (évite d'utiliser `print` directement)
    private static func appLogger(_ prefix: String, _ message: String) {
        // Vapor n'expose pas de logger global ici, on utilise print pour simplicité
        print("[\(prefix)] \(message)")
    }
}
