import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport/SeeTrainingPage.dart';
import 'CreateTrainingPage.dart';
import 'HomePage.dart';

class Training extends StatefulWidget {
  const Training({Key? key}) : super(key: key);


  @override
  State<Training> createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  List<Map<String, dynamic>> seancesList = [];
  List<Container> containerList = [];

  List<Map<String, dynamic>> exerciceList = [];

  int nbSeance = 0;

  @override
  void initState() {
    super.initState();
    chargerValeurs();
  }

  void sauvegarderValeurs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> seancesListJson = seancesList.map((seanceData) {
      String description = seanceData['description'];
      String seance = seanceData['seance'];
      String? imagePath = seanceData['imagePath'];
      List<Map<String, dynamic>> exerciceList = seanceData['exerciceList'];


      List<String> exerciceListJson = exerciceList.map((exercice) {
        String exerciceJson = jsonEncode(exercice);
        return exerciceJson;
      }).toList();

      Map<String, dynamic> seanceJson = {
        'description': description,
        'seance': seance,
        'imagePath': imagePath,
        'exerciceList': exerciceListJson,
      };
      return seanceJson;
    }).toList();

    String seancesListJsonString = jsonEncode(seancesListJson);
    await prefs.setString('seancesList', seancesListJsonString);

    await prefs.setInt('nbSeance', nbSeance);
  }


  void chargerValeurs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String? seancesListJsonString = prefs.getString('seancesList');
      if (seancesListJsonString != null) {
        List<dynamic> seancesListJson = jsonDecode(seancesListJsonString);

        seancesList = seancesListJson.map((seanceJson) {
          String description = seanceJson['description'];
          String seance = seanceJson['seance'];
          String? imagePath = seanceJson['imagePath'];
          List<String> exerciceListJson = List<String>.from(seanceJson['exerciceList']);

          List<Map<String, dynamic>> exerciceList = exerciceListJson.map((exerciceJson) {
            Map<String, dynamic> exercice = jsonDecode(exerciceJson);
            return exercice;
          }).toList();

          return {
            'description': description,
            'seance': seance,
            'imagePath': imagePath,
            'exerciceList': exerciceList,
          };
        }).toList();

        parcourirSeancesList();
      }

      int? savedNbSeance = prefs.getInt('nbSeance');
      if (savedNbSeance != null) {
        setState(() {
          nbSeance = savedNbSeance;
        });
      }

    });
  }


  void parcourirSeancesList() {
    for (var seanceData in seancesList) {
      String description = seanceData['description'];
      String seance = seanceData['seance'];
      String? imagePath = seanceData['imagePath'];
      List<Map<String, dynamic>> exerciceList = seanceData['exerciceList'];

      Container newSeanceContainer = Container(
        child: GestureDetector(
          onTap: () {
            int index = seancesList.indexOf(seanceData);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeeTraining(seance: seance, imagePath: imagePath, description: description, exerciceList: seancesList[index])),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Color(0xFF696969),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 110,
                  margin: EdgeInsets.only(left: 5),
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
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              seance,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Text(
                              exerciceList.length.toString() + " exercices",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFBBBBBB),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      setState(() {
        containerList.add(newSeanceContainer);
        sauvegarderValeurs();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xFF1F1F1F),
        ),
        child: ListView(
          children: [
          new Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              margin: EdgeInsets.only(top: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Ta bibliothéque",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFBBBBBB)),
                  ),
                  Text(
                    "De séances",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0),
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 180,
                    height: 70,
                    margin: EdgeInsets.only(left: 35),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF696969), width: 5),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),  // Marge de 20 pixels à gauche de l'image
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/search.png",
                            alignment: Alignment.centerLeft,
                          ),
                          SizedBox(width: 10), // Espacement entre l'image et le texte
                          Text(
                            "Search...",
                            style: TextStyle(
                                fontSize: 25,
                                color: Color(0xFFBBBBBB)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic>? result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateTraining()),
                      );
                      nbSeance++;
                      if (result != null) {
                        String description = result['description'];
                        String seance = result['seance'];
                        String? imagePath = result['imagePath'];
                        exerciceList = result['listeExercice'];

                        if (seance == "")
                          seance = "Seance " + nbSeance.toString();

                        Map<String, dynamic> seanceData = {
                          'description': description,
                          'seance': seance,
                          'imagePath': imagePath,
                          'exerciceList': exerciceList,
                        };

                        seancesList.add(seanceData);

                        Container newSeanceContainer = Container(
                          child: GestureDetector(
                            onTap: () {
                              int index = seancesList.indexOf(seanceData);
                              print (index);
                              print('->' + seancesList[index].toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SeeTraining(seance: seance, imagePath: imagePath, description: description, exerciceList: seancesList[index])),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Color(0xFF696969),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 110,
                                    margin: EdgeInsets.only(left: 5),
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
                                  Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(
                                                seance,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              child: Text(
                                                exerciceList.length.toString() + " exercices",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xFFBBBBBB),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        setState(() {
                          containerList.add(newSeanceContainer);
                          sauvegarderValeurs();
                        });
                        //_buildTrainingListContainer();
                      }
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      margin: EdgeInsets.only(left: 30),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(50, 219, 255, 0),
                        borderRadius: BorderRadius.circular(40),
                        image:
                        DecorationImage(image: AssetImage("assets/add.png")),
                      ),
                    ),
                  )
                ],
              ),
            ),
            _buildTrainingListContainer(),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 35, left: 30, right: 30),
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Color(0xFF969696),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.only(
                          left: (MediaQuery.of(context).size.width - 180) / 4),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/homeN.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width - 180) / 4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/trainingJ.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width - 180) / 4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/stats.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTrainingListContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 430,
      margin: EdgeInsets.only(top: 20, left: 35, right: 35),
      child: ListView.builder(
        itemCount: containerList.length,
        itemBuilder: (context, index) {
          return containerList[index];
        },
      ),
    );
  }


}