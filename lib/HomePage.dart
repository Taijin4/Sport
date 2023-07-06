import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'TrainingPage.dart';

DateTime maintenant = DateTime.now();
String dateFormatee = DateFormat('dd/MM').format(maintenant);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class CircleBorderPainter extends CustomPainter {
  final double percentage;

  CircleBorderPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(293 / 1.4, 293 / 2);
    final radius = 293 / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final path = Path()
      ..addArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi);

    final gradient = LinearGradient(
      colors: [Color(0xFFD8FF00), Colors.black],
      stops: [percentage / 100, percentage / 100],
      begin: Alignment(-1.25, 0.2),
      end: Alignment(1.25, 0.1),
    );

    paint.shader = gradient.createShader(path.getBounds());

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _HomeState extends State<Home> {
  String textWeigth = "";
  String textHeight = "";
  int nbSeances = 1;
  FixedExtentScrollController scrollController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    chargerValeurs();
  }

  void chargerValeurs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int valeurSauvegardee = prefs.getInt('nbSeances') ?? 1;
    setState(() {
      textWeigth = prefs.getString('textWeigth') ?? "68.5";
      textHeight = prefs.getString('textHeight') ?? "175";
      nbSeances = valeurSauvegardee;
      scrollController.jumpToItem(nbSeances - 1); // Mise à jour de la position du contrôleur
    });
  }

  void sauvegarderValeurs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('textWeigth', textWeigth);
    await prefs.setString('textHeight', textHeight);
    await prefs.setInt('nbSeances', nbSeances);
  }

  void afficherRoulette() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier la valeur'),
          content: Container(
            height: 200,
            child: CupertinoPicker(
              itemExtent: 50,
              scrollController: scrollController,
              onSelectedItemChanged: (int index) {
                setState(() {
                  nbSeances = index ; // Mettre à jour la valeur sélectionnée
                });
              },
              children: List<Widget>.generate(8, (int index) {
                return Center(
                  child: Text(
                    (index).toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Enregistrer'),
              onPressed: () {
                sauvegarderValeurs();
                Navigator.of(context).pop(); // Fermer la boîte de dialogue après avoir enregistré les modifications
              },
            ),
          ],
        );
      },
    );
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    padding: EdgeInsets.only(top: 35.0, left: 35),
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Salut,",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFBBBBBB)),
                        ),
                        Text(
                          "Antonin",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        new Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(top: 35, right: 35),
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/settings.png")),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ClipRect(
              child: new Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 5),
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: CircleBorderPainter((nbSeances * 100) / 7),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: GestureDetector(
                          onTap: afficherRoulette,
                          child: Container(
                            margin: EdgeInsets.only(top : 0),
                            child: Text(
                              nbSeances.toString(),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 80),
                        child: Text(
                          'séance \ncette semaine',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFBBBBBB)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 40, left: 30, right: 30),
              height: 150,
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 74) / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF969696),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 60,
                          height: 66,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/weigth.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String nouveauTexte = textWeigth; // Initial value of the text
                                return AlertDialog(
                                  title: Text('Modify Text'),
                                  content: TextFormField(
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    controller: TextEditingController(text: nouveauTexte),
                                    onChanged: (value) {
                                      nouveauTexte = value; // Update the variable with the entered value
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
                                        if (nouveauTexte.isEmpty) {
                                          // Vérifier si le champ de texte est vide
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Error'),
                                                content: Text('Text field cannot be empty.'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Fermer la boîte de dialogue d'erreur
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setString('textWeigth', nouveauTexte); // Enregistrer la nouvelle valeur dans les préférences partagées
                                          setState(() {
                                            textWeigth = nouveauTexte; // Mettre à jour la valeur affichée dans l'interface utilisateur
                                          });
                                          Navigator.of(context).pop(); // Fermer la boîte de dialogue après avoir enregistré les modifications
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              textWeigth,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7),
                    width: (MediaQuery.of(context).size.width - 74) / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF969696),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 60,
                          height: 74,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/height.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String nouveauTexte = textHeight; // Initial value of the text
                                return AlertDialog(
                                  title: Text('Modify Text'),
                                  content: TextFormField(
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    controller: TextEditingController(text: nouveauTexte),
                                    onChanged: (value) {
                                      nouveauTexte = value; // Update the variable with the entered value
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
                                        if (nouveauTexte.isEmpty) {
                                          // Vérifier si le champ de texte est vide
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Error'),
                                                content: Text('Text field cannot be empty.'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Fermer la boîte de dialogue d'erreur
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setString('textHeight', nouveauTexte); // Enregistrer la nouvelle valeur dans les préférences partagées
                                          setState(() {
                                            textHeight = nouveauTexte; // Mettre à jour la valeur affichée dans l'interface utilisateur
                                          });
                                          Navigator.of(context).pop(); // Fermer la boîte de dialogue après avoir enregistré les modifications
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Text(
                              textHeight,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 7),
                    width: (MediaQuery.of(context).size.width - 74) / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF969696),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 62,
                          height: 66,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/calendar.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            dateFormatee,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, left: 30, right: 30),
              height: 170,
              decoration: BoxDecoration(
                  color: Color(0xFF969696),
                  borderRadius: BorderRadius.circular(20)),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Image.asset(
                      'assets/quote.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Image.asset(
                      'assets/quote2.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "C'EST DANS L'INCONFORT,",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "que l'on devient plus \nfort",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal, color: Colors.white),
                          textAlign: TextAlign.center,

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                  Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width - 180) / 4),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/home.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                        MaterialPageRoute(builder: (context) => Training()),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.only(
                          left: (MediaQuery.of(context).size.width - 180) / 4),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/training.png"),
                          fit: BoxFit.contain,
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
}