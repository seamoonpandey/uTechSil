class Utensil {
  String? id;
  String? name;
  String? imageUrl;
  String? description;
  List<String>? uses;
  List<String>? material;
  List<String>? subImages;

  Utensil({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.uses,
    this.material,
    this.subImages,
  });

  // Method to convert Utensil instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'uses': uses,
      'material': material,
    };
  }

  // Factory constructor to create Utensil instance from JSON map
  factory Utensil.fromJson(Map<String, dynamic> json) {
    return Utensil(
        id: json['_id'] as String?,
        name: json['name'] as String?,
        imageUrl: json['image'] as String? ?? "",
        description: json['description'] as String?,
        uses: (json['uses'] as List<dynamic>?)
            ?.map((final e) => e as String)
            .toList(),
        material: (json['material'] as List<dynamic>?)
            ?.map((final e) => e as String)
            .toList(),
        subImages: (json['subImages'] as List<dynamic>?)
            ?.map((final e) => e as String)
            .toList());
  }
}
