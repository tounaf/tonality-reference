// chanson_model.dart

class Chanson {
  int? id;
  String tonalite;
  String title;
  String description;
  List<String> categories;

  Chanson({
    this.id,
    required this.tonalite,
    required this.title,
    required this.description,
    required this.categories,
  });

  // Convertir un objet Chanson en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tonalite': tonalite,
      'title': title,
      'description': description,
      'categories': categories.join(', '), // Convertir la liste en chaîne pour le stockage
    };
  }

  // Convertir un Map en objet Chanson
  factory Chanson.fromMap(Map<String, dynamic> map) {
    return Chanson(
      id: map['id'],
      tonalite: map['tonalite'],
      title: map['title'],
      description: map['description'],
      categories: map['categories'].split(', '), // Convertir la chaîne en liste lors de la lecture
    );
  }
}
