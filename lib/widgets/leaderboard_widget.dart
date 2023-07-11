import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({
    super.key,
    required bool isResultVisible,
  }) : _isResultVisible = isResultVisible;

  final bool _isResultVisible;

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  int players = 0;
  List<String> points = [];
  List<String> phases = [];
  List<String> names = [];
  getResults() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      players = (prefs.getDouble("players")!.roundToDouble()).toInt();
      points = prefs.getStringList("points")!..removeAt(0);
      phases = prefs.getStringList("phases")!..removeAt(0);
      names = prefs.getStringList("names")!..removeAt(0);
    });

    List<int> indices = List.generate(points.length, (index) => index);

    indices.sort((a, b) {
      double pointsA = double.parse(points[a]);
      double pointsB = double.parse(points[b]);

      int pointsComparison = pointsA.compareTo(pointsB);
      if (pointsComparison != 0) {
        return pointsComparison;
      } else {
        return phases[b].compareTo(
            phases[a]); // Inverti l'ordine di "phases" invertendo gli indici
      }
    });

    points = indices.map((index) => points[index]).toList();
    phases = indices.map((index) => phases[index]).toList();
    names = indices.map((index) => names[index]).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isResultVisible) getResults();
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: widget._isResultVisible ? 40 : -480,
      left: 20,
      right: 20,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 255, 60, 1),
              Color.fromRGBO(242, 180, 50, 1),
              Color.fromRGBO(255, 255, 60, 1),
            ],
            stops: [0, 0.53, 1],
            transform: GradientRotation(61 * 3.1415926535 / 180),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(242, 180, 50, 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(355),
              ),
              border: Border.all(color: Colors.black, width: 5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: const Text(
              "CLASIFICACIÓN",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          if (players > 0) createResults(),
          const SizedBox(height: 20)
        ]),
      ),
    );
  }

  Column createResults() {
    List<Widget> allResults = [];
    for (int i = 0; i < players; i++) {
      allResults.add(SingleResult(i, points[i], names[i], phases[i]));
    }
    return Column(children: allResults);
  }
}

class SingleResult extends StatelessWidget {
  final int i;
  final String points;
  final String name;
  final String phase;

  const SingleResult(
    this.i,
    this.points,
    this.name,
    this.phase, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(115, 84, 20, 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(355),
        ),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${i + 1}. $name",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          Text(
            "    $points  ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          CircleAvatar(
            radius: 12,
            child: Text(
              phase,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
