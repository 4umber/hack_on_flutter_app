import 'dart:convert';

class HumCity {
  String name;
  String code;

  HumCity({required this.name, required this.code});
}

class CitiesProvider {
  static List<HumCity> getCities(String json) {
    final parsedCities = jsonDecode(json);
    List<HumCity> cities = [];

    print(parsedCities);

    for (var city in parsedCities['cities']) {
      print(city);
      cities.add(HumCity(name: city['name'], code: city['code']));
    }

    return cities;
  }
}
