class Ingredient {
  String? docId;
  String? name;
  List<String>? users_ids;

  Ingredient();

  Ingredient.fromJson(Map<String, dynamic> data, [String? id]) {
    docId = id;
    name = data['name'];
    users_ids = data['users_ids'] != null
        ? List<String>.from(data['users_ids'].map((e) => e.toString()))
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "users_ids": users_ids,
    };
  }
}