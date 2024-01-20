import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeeExercice extends StatefulWidget {
  final String exercice;
  final String objectif;
  final String poids;

  const SeeExercice({
    required this.exercice,
    required this.objectif,
    required this.poids,
    Key? key,
  }) : super(key: key);

  @override
  State<SeeExercice> createState() => _SeeExerciceState();
}

class _SeeExerciceState extends State<SeeExercice> {
  bool isFavorite = false;
  bool isDelete = false;

  void _addFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _delete() {
    isDelete = true;

  }

  @override
  Widget build(BuildContext context) {
    final exercice = widget.exercice;
    final objectif = widget.objectif;
    final poids = widget.poids;

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
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 40),
            child: Text(
              exercice,
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 40, left: 35, right: 35),
            child: Text(
              "Objectif : " + objectif,
              style: TextStyle(fontSize: 23, color: Colors.white),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 120, left: 35, right: 35),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Dernier PR",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Text(
                          "0",
                          style:
                              TextStyle(fontSize: 25, color: Color(0xFFBBBBBB)),
                        ),
                      ), // Remplacez 0 par votre valeur minimale réelle
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                poids.toString(),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDBFF00)),
                              ),
                            ),
                            Slider(
                              activeColor: Color(0xFFDBFF00),
                              inactiveColor: Color(0xFFD9D9D9),
                              value: double.parse(poids),
                              min: 0,
                              max: 160,
                              divisions: 160 * 4,
                              onChanged: (double value) {},
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 32),
                        child: Text(
                          "160",
                          style:
                              TextStyle(fontSize: 25, color: Color(0xFFBBBBBB)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 120, left: 35, right: 35),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.star_rate_rounded
                                : Icons.star_border_rounded,
                            color: Color(0xFFD8FF00),
                          ),
                          iconSize: 65,
                          onPressed: () {
                            _addFavorite();
                          },
                        ),
                      ),
                      Container(
                        child: Text(
                          "Ajouter aux favoris",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Color(0xFFD91C1C),
                          ),
                          iconSize: 65,
                          onPressed: (){
                            _showCustomDialog(context);
                          },
                        ),
                      ),
                      Container(
                        child: Text(
                          "Supprimer",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1F1F1F),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          content: Container(
            width: 3000.0, // Définissez la largeur de la boîte de dialogue.
            height: 330.0, // Définissez la hauteur de la boîte de dialogue.
            padding: EdgeInsets.only(top: 25, left: 10, right: 10),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Icon(
                    Icons.delete,
                    color: Color(0xFFD91C1C),
                    size: 65,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Supprimer ?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Text(
                    'Voulez-vous vraiment supprimer cet exercice ?',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color(0xFF8888888),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 35, right: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          _delete();
                          Navigator.pop(context, {'delete' : isDelete});
                        },
                        child: Text(
                          'Oui',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDBFF00),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Non',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDBFF00),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


}
