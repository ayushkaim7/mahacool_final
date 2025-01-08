class ResponseModel {
  List<String> cityNames;
  List<Map<String, dynamic>> warehouseList;
  String dryFruitNames;

  ResponseModel({
    this.cityNames = const [],
    this.warehouseList = const [],
    this.dryFruitNames = "",
  });

  // Factory to parse the JSON response
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    // Extract check-in history
    List<dynamic> checkInHistory = json['checkInHistory'] ?? [];

    // Extract unique city names
    Set<String> cities = {};
    Map<String, double> warehouseMap = {};
    Set<String> dryFruits = {};

    for (var history in checkInHistory) {
      List<dynamic> dryFruitsList = history['dryFruits'] ?? [];

      for (var dryFruit in dryFruitsList) {
        // Collect city names
        String city = dryFruit['cityName'] ?? "Unknown City";
        cities.add(city);

        // Aggregate warehouse weight
        String warehouse = dryFruit['warehouseName'] ?? "Unknown Warehouse";
        double weight = (dryFruit['weight'] as num?)?.toDouble() ?? 0.0;
        warehouseMap[warehouse] = (warehouseMap[warehouse] ?? 0.0) + weight;

        // Collect dry fruit names
        String fruitName = dryFruit['name'] ?? "Unknown Fruit";
        dryFruits.add(fruitName);
      }
    }

    // Convert warehouse map to a list of maps
    List<Map<String, dynamic>> warehouseList = warehouseMap.entries
        .map((entry) => {"warehouseName": entry.key, "weight": entry.value})
        .toList();

    return ResponseModel(
      cityNames: cities.toList(),
      warehouseList: warehouseList,
      dryFruitNames: dryFruits.join(", "),
    );
  }
}
