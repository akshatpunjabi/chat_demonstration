import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class NotesPage extends StatefulWidget {
  String subjectName;
  DocumentSnapshot userData;
  NotesPage(String subjectName, DocumentSnapshot userData) {
    this.userData = userData;
    this.subjectName = subjectName;
  }
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  DocumentSnapshot ds;
  DocumentReference docref = FirebaseFirestore.instance
      .collection('subjects_pdf')
      .doc('7PpIiKLM0YW3TmsGPNye');

  Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    File file = await FilePicker.getFile(type: FileType.custom);
    String fileName = '${randomName}.pdf';
    savePdf(file.readAsBytesSync(), fileName);
  }

  savePdf(List<int> asset, String name) async {
    Reference reference = FirebaseStorage.instance.ref().child(name);
    UploadTask uploadTask = reference.putData(asset);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    String url = imageUrl.toString();
    print(url);

    docref.update({
      widget.subjectName: FieldValue.arrayUnion([url])
    });
  }

  @override
  void initState() {
    getDocumentSnapshot();
    super.initState();
  }

  getDocumentSnapshot() async {
    ds = await FirebaseFirestore.instance
        .collection('subjects_pdf')
        .doc('7PpIiKLM0YW3TmsGPNye')
        .get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("subjects_pdf")
            .doc("7PpIiKLM0YW3TmsGPNye")
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            Fluttertoast.showToast(
                msg: "Error: ${snapshot.error}",
                toastLength: Toast.LENGTH_SHORT);
            return Container();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                color: Colors.white,
                child: Center(
                    child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )),
              );
            default:
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.red,
                  title: Text("Lecture Slides"),
                ),
                body: ds == null
                    ? Container(
                        color: Colors.white,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        itemCount: ds.data()[widget.subjectName].length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: GestureDetector(
                                onTap: () async {
                                  await launch(
                                      ds.data()[widget.subjectName][index]);
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('images/pdf.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        height: 140,
                                        child: Card(
                                          margin: EdgeInsets.all(18),
                                          elevation: 7.0,
                                          child: Center(
                                            child: Text(
                                              "Lecture slide " +
                                                  (index + 1).toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                floatingActionButton: widget.userData.data()['isInstructor']
                    ? FloatingActionButton(
                        onPressed: () {
                          getPdfAndUpload();
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.red,
                      )
                    : null,
              );
          }
        });
  }
}
