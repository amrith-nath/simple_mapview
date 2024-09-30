import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logicart/data/models/location_model.dart';
import 'package:logicart/screens/screen_map.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    List<LocationModel> locations = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        children: [
          const Text(
            "Locations",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
              child: FutureBuilder<List<LocationModel>>(
                  future: getLocations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Text("No data found");
                    }
                    locations = snapshot.data!;
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var location = snapshot.data![index];

                          return ListTile(
                            leading: const Icon(
                              Icons.place,
                              color: Colors.green,
                            ),
                            title: Text(
                              "Location $index",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                "Lat: ${location.latitude}  --- Lon: ${location.longitude}"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          );
                        });
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.map), Text("Google maps")],
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ScreenMap(
                locations: locations,
              ),
            ));
          }),
    );
  }

  Future<List<LocationModel>> getLocations() async {
    try {
      final jsnstrng = await rootBundle.loadString("assets/data.json");

      final jsndata = jsonDecode(jsnstrng) as List;

      List<LocationModel> locations =
          jsndata.map((e) => LocationModel.fromJson(e)).toList();
      return locations;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
