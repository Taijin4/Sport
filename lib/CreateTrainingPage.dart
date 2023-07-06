import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ExercicePage.dart';

class CreateTraining extends StatefulWidget {
  const CreateTraining({Key? key}) : super(key: key);

  @override
  State<CreateTraining> createState() => _CreateTrainingState();
}

class _CreateTrainingState extends State<CreateTraining> {
  int i = 0;

  String description = "";
  TextEditingController descriptionController = TextEditingController();

  String seance = "";
  TextEditingController seanceController = TextEditingController();


  late SharedPreferences prefs;

  String? imagePath;

  List<Widget> exerciceContainerList = [];
  List<Map<String, dynamic>> exerciceList = [];

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    seanceController.text = seance;
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    String? savedUserInput = prefs.getString("description");
    if (savedUserInput != null) {
      setState(() {
        description = savedUserInput;
      });
    }
  }

  @override
  void dispose() {
    saveUserInput();
    super.dispose();
  }

  Future<void> saveUserInput() async {
    await prefs.setString('description', description);
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
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 35),
              alignment: Alignment.center,
              child: Text(
                "Crée une séance",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 35, right: 35, top: 62),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            pickMedia();
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.only(top: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFC4C4C4),
                              image: imagePath != null
                                  ? DecorationImage(
                                image: FileImage(File(imagePath!)),
                                fit: BoxFit.cover,
                              )
                                  : DecorationImage(
                                image: AssetImage("assets/addPicture.png"),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 191,
                          margin: EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: seanceController,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold ,color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Seance",
                              hintStyle: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold ,color: Colors.white),
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
                                seance = value;
                                print(seance);
                              });
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, {'description' : description, 'seance' : seance, 'imagePath' : imagePath, 'listeExercice' : exerciceList});
                          },
                          child:
                          Container(
                            width: 60,
                            height: 50,
                            margin: EdgeInsets.only(top: 18),
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
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: TextField(
                            controller: descriptionController,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontSize: 25, color: Color(0xFF696969)),
                            decoration: InputDecoration(
                              hintText: 'Description...',
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
                                description = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 2,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 430,
                    margin: EdgeInsets.only(top : 40),
                    child: ListView(
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Text(
                                  "Exercices",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Map<String, dynamic>? result =
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Exercice()));
                                  if (result != null) {
                                    String exercice = result['exercice'];
                                    String objectif = result['objectif'];
                                    String poids = result['poids'];
                                    if (poids == "")
                                      poids = '80';

                                    Map<String, dynamic> seanceData = {
                                      'exercice': exercice,
                                      'objectif': objectif,
                                      'poids': poids,
                                    };

                                    exerciceList.add(seanceData);

                                    Container newExerciceContainer = Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 90,
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Color(0xFF696969),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            margin: EdgeInsets.only(left: 15),
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    50, 219, 255, 0),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                  (i+1).toString(),
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFDBFF00)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 15, left: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    exercice,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  width: 230,
                                                  height: 20,
                                                  child: Text(
                                                    objectif,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xFFBBBBBB)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                    setState(() {
                                      i++;
                                      exerciceContainerList.add(newExerciceContainer);
                                    });
                                    _buildexerciceListContainer();
                                  }
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(left: 172),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage("assets/add.png"))),
                                ),
                              )
                            ],
                          ),
                        ),
                        _buildexerciceListContainer(),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 3,
                          color: Colors.white,
                        )
                      ],
                    ),

                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void pickMedia() async{
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null){
      imagePath = file.path;
      setState(() {

      });
    }
  }

  Container _buildexerciceListContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (i * 110).toDouble().clamp(0, 350),
      margin: EdgeInsets.only(top: 20),
      child: ListView.builder(
        itemCount: exerciceContainerList.length,
        itemBuilder: (context, index) {
          return exerciceContainerList[index];
        },
      ),
    );
  }

}
