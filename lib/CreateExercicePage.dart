
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Exercice extends StatefulWidget {

  const Exercice({super.key});

  @override
  State<Exercice> createState() => _ExerciceState();
}

class _ExerciceState extends State<Exercice> {
  String exercice = "";
  TextEditingController exerciceController = TextEditingController();

  String objectif = "";
  TextEditingController objectifController = TextEditingController();

  double _currentSliderSecondaryValue = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: const BoxDecoration(
          color: Color(0xFF1F1F1F),
        ),
        child: ListView(
          children: [
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: EdgeInsets.only(top: 35),
              alignment: Alignment.center,
              child: Text(
                "Ajoute ton exercice",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: EdgeInsets.only(left: 35, right: 35, top: 62),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.only(top: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  "Exercice",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, {'exercice' : exercice, 'objectif' : objectif, 'poids' : _currentSliderSecondaryValue.toString()});
                                },
                                child: Container(
                                  width: 40,
                                  height: 30,
                                  margin: EdgeInsets.only(top: 18, left: 186),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/valider.png"),
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: exerciceController,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontSize: 25, color: Color(0xFF696969)),
                            decoration: InputDecoration(
                              hintText: 'Développé couché...',
                              hintStyle: TextStyle(
                                  fontSize: 25, color: Color(0xFF696969)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.transparent),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                exercice = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 2,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: EdgeInsets.only(left: 35, right: 35, top: 30),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Objectif",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: objectifController,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontSize: 25, color: Color(0xFF696969)),
                            decoration: InputDecoration(
                              hintText: '4 * 10 reps',
                              hintStyle: TextStyle(
                                  fontSize: 25, color: Color(0xFF696969)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.transparent),
                              ),
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                objectif = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 2,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: EdgeInsets.only(left: 35, right: 35, top: 85),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Dernier PR",
                      style: TextStyle(fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Text(
                            "0",
                            style: TextStyle(
                                fontSize: 25, color: Color(0xFFBBBBBB)),
                          ),
                        ), // Remplacez 0 par votre valeur minimale réelle
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        String poids = _currentSliderSecondaryValue.toString();
                                        return AlertDialog(
                                          title: Text('Modify Text'),
                                          content: TextFormField(
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            controller: TextEditingController(text: poids),
                                            onChanged: (value) {
                                              poids = value; // Update the variable with the entered value
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog without saving the changes
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Save'),
                                              onPressed: () async {
                                                if (poids.isEmpty) {
                                                  // Vérifier si le champ de texte est vide
                                                  poids = 0.toString();
                                                }
                                                setState(() {
                                                  _currentSliderSecondaryValue = double.parse(poids); // Mettre à jour la valeur affichée dans l'interface utilisateur
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                },
                                child: Container(
                                  child: Text(
                                    _currentSliderSecondaryValue.toString(),
                                    style: TextStyle(fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFDBFF00)),
                                  ),
                                ),
                              ),
                              Slider(
                                activeColor: Color(0xFFDBFF00),
                                inactiveColor: Color(0xFFD9D9D9),
                                value: _currentSliderSecondaryValue,
                                min: 0,
                                // Remplacez 0 par votre valeur minimale réelle
                                max: 160,
                                // Remplacez 100 par votre valeur maximale réelle
                                divisions: 160 * 4,
                                onChanged: (double value) {
                                  setState(() {
                                    _currentSliderSecondaryValue = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 32),
                          child: Text(
                            "160",
                            style: TextStyle(
                                fontSize: 25, color: Color(0xFFBBBBBB)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
