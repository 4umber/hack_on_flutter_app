import 'package:flutter/material.dart';
import '../providers/hum_points_provider.dart';
import '../providers/cities_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class HumanitarianWindow extends StatefulWidget {
  const HumanitarianWindow({super.key, required this.defaultCity});

  final HumCity defaultCity;

  @override
  State<HumanitarianWindow> createState() => _HumanitarianWindowState();
}

class _HumanitarianWindowState extends State<HumanitarianWindow>
    with AutomaticKeepAliveClientMixin {
  late Future<List<HumPoint>> futureHumPoints;
  List<HumCity> cities = [];
  HumCity selectedCity = HumCity(name: '', code: '');

  @override
  bool get wantKeepAlive => true;

  Future<void> loadCitiesJson() async {
    String cities_json = await rootBundle.loadString('assets/data/cities.json');
    cities = CitiesProvider.getCities(cities_json);
  }

  @override
  void initState() {
    super.initState();
    selectedCity = widget.defaultCity;
    loadCitiesJson();
    futureHumPoints = HumPointsProvider.getHumPoints(selectedCity.code);
  }

  Widget buildHumPoint(HumPoint point) {
    return Card(
      child: ExpansionTile(
        title: Text(
          point.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        expandedAlignment: Alignment.centerLeft,
        children: <Widget>[
          Text(
            point.description,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedCity.name,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            IconButton(
              onPressed: () async {
                var search_result = await showSearch(
                  context: context,
                  delegate: CitySearchDelegate(searchCities: cities),
                );

                if (search_result != null) {
                  selectedCity = search_result;
                  futureHumPoints =
                      HumPointsProvider.getHumPoints(selectedCity.code);
                  setState(() {});
                }
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<HumPoint>>(
            future: futureHumPoints,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return buildHumPoint(snapshot.data!.elementAt(index));
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }
}

class CitySearchDelegate extends SearchDelegate<HumCity?> {
  CitySearchDelegate({required this.searchCities});
  List<HumCity> searchCities = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        query = '';
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  ListTile buildListItem(BuildContext context, HumCity city) {
    return ListTile(
      title: Text(city.name),
      onTap: () {
        close(context, city);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<HumCity> matchQuery = searchCities
        .where(
          (city) => city.name.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return buildListItem(context, matchQuery[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<HumCity> matchQuery = searchCities
        .where(
          (city) => city.name.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return buildListItem(context, matchQuery[index]);
      },
    );
  }
}
