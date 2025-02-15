import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_mapkit_example/examples/widgets/map_page.dart';

class SearchPage extends MapPage {
  const SearchPage() : super('Search example');

  @override
  Widget build(BuildContext context) {
    return _SearchExample();
  }
}

class _SearchExample extends StatefulWidget {
  @override
  _SearchExampleState createState() => _SearchExampleState();
}

class _SearchExampleState extends State<_SearchExample> {
  TextEditingController queryController = TextEditingController();
  String response = '';

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
            const Text('Input part of address:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: queryController,
                    onChanged: (text) => querySuggestions(queryController.text),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Suggest:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(child: Text(response)),
              ],
            ),
          ])))
        ]);
  }

  Future<void> querySuggestions(String query) async {
    final session = await YandexSearch.getSuggestions(
      address: query,
      southWestPoint: const Point(latitude: 55.5143, longitude: 37.24841),
      northEastPoint: const Point(latitude: 56.0421, longitude: 38.0284),
      suggestType: SuggestType.geo,
      suggestWords: true,
    );
    Future.delayed(const Duration(seconds: 3), () => session.cancelSession());
    final result = await session.result;
    setState(() {
      response =
          result.items?.map((SuggestItem item) => item.title).join('\n') ??
              'Error: ${result.error}';
    });
  }
}
