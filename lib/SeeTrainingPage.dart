import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class SeeTraining extends StatefulWidget {
  final String seance;
  final String? imagePath;
  final String description;
  final Map<String, dynamic> exerciceList;

  const SeeTraining({
    required this.seance,
    required this.imagePath,
    required this.description,
    required this.exerciceList,
    Key? key,
  }) : super(key: key);

  @override
  State<SeeTraining> createState() => _SeeTrainingState();
}

class _SeeTrainingState extends State<SeeTraining> {
  List<Container> containerList = [];

  void chargerExercices(Map<String, dynamic> exerciceList) {
    int nb = 0;

    if (exerciceList.containsKey('exerciceList')) {
      List<Map<String, dynamic>> exercices = exerciceList['exerciceList'];
      for (var exerciceData in exercices)
        {
          nb++;
          String exercice = exerciceData['exercice'];
          String objectif = exerciceData['objectif'];
          String poids = exerciceData['poids'];

          Container exerciceContainer = Container(
            width: MediaQuery.of(context).size.width,
            height: 90,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: Color(0xFF696969),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(50, 219, 255, 0),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      (nb).toString(),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDBFF00)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          exercice,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 230,
                        height: 20,
                        child: Text(
                          objectif,
                          style:
                          TextStyle(fontSize: 15, color: Color(0xFFBBBBBB)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );

          containerList.add(exerciceContainer);
        }
    }

  }

  @override
  Widget build(BuildContext context) {
    // Utilisez les arguments dans votre build() ou dans d'autres méthodes de cette classe
    final seance = widget.seance;
    final imagePath = widget.imagePath;
    final description = widget.description;
    final exerciceList = widget.exerciceList;

    print(exerciceList);

    chargerExercices(exerciceList);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xFF1F1F1F),
        ),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, left: 35, right: 35),
              child: Text(
                seance,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 35, right: 35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color(0xFFBBBBBB),
                      borderRadius: BorderRadius.circular(10),
                      image: imagePath != null
                          ? DecorationImage(
                              image: FileImage(File(imagePath)),
                              fit: BoxFit.fill,
                            )
                          : null,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 221,
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60, left: 35, right: 35),
              child: Text(
                "Exercices",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25, left: 35, right: 35),
              height: 470,
              child: ListView(
                  children: containerList,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
