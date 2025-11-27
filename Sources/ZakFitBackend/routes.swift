import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: TodoController())
    //  User
    let userController = UserController()
    try app.register(collection: userController)

       //  ExerciseType
       try app.register(collection: ExerciseTypeController())

//       //  Exercise
//       try app.register(collection: ExerciseController())
//
//       //  Food
//       try app.register(collection: FoodController())
//
//       //  MealType
//       try app.register(collection: MealTypeController())
//
//       //  Meal
//       try app.register(collection: MealController())
//
//       //  MealFood
//       try app.register(collection: MealFoodController())
//    
//    //  Goals
//      try app.register(collection: GoalController())
//
//      //  Notifications
//      try app.register(collection: NotificationController())
//
//      //  Weight tracking
//      try app.register(collection: WeightTrackingController())

    
   
}


