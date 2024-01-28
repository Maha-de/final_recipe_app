class Recipe {
  String? docId;
  String? title;
  String? description;
  String? calories;
  String? total_time;
  String? servings;
  String? ingredients;

  Recipe();

  Recipe.fromJson(Map<String, dynamic> data, [String? id]) {
    docId = id;
    title = data['title'];
    description = data['description'];
    calories = data['calories'];
    total_time = data['total_time'];
    servings = data['servings'];
    ingredients = data['ingredients'];
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "calories": calories,
      "total_time": total_time,
      "servings": servings,
      "ingredients": ingredients,
    };
  }
}