class Recipe {
  String? docId;
  String? title;
  String? description;
  Map<String, String>? directions;
  String? calories;
  String? image_url;
  String? total_time;
  String? servings;
  List<String>? ingredients;
  List<String>? favourite_users_ids;
  String? rate;
  String? type;




  Recipe();

  Recipe.fromJson(Map<String, dynamic> data, [String? id]) {
    docId = id;
    title = data['title'];
    description = data['description'];
    directions = data['directions'] != null ?
    Map<String, String>.from(data['directions']): null;
    calories = data['calories'];
    image_url = data['image_url'];
    total_time = data['total_time'];
    servings = data['servings'];
    ingredients = data['ingredients'] != null
        ? List<String>.from(data['ingredients'].map((e) => e.toString()))
        : null;
    favourite_users_ids = data['favourite_users_ids'] != null
        ? List<String>.from(
        data['favourite_users_ids'].map((e) => e.toString()))
        : null;
    type = data['type'];
    rate = data['rate'];


  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "directions": directions,
      "image_url": image_url,
      "type": type,
      "rate": rate,
      "calories": calories,
      "total_time": total_time,
      "servings": servings,
      "ingredients": ingredients,
    };
  }
}