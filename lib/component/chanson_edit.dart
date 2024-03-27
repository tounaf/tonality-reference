// nouvelle_chanson_screen.dart
import 'package:flutter/material.dart';
import 'package:song/component/chanson_list.dart';
import 'package:song/model/chanson.dart';
import 'package:song/db/database_helper.dart';

class ChansonEditScreen extends StatefulWidget {
  
  Chanson? chanson;

  ChansonEditScreen(this.chanson);

  @override
  _ChansonEditScreenState createState() => _ChansonEditScreenState();
}

class _ChansonEditScreenState extends State<ChansonEditScreen> {
  final TextEditingController tonaliteController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();
  String _textEditButton = "Ajouter";
  String _titleEdit = "Nouvelle Chanson";
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.chanson != null) {
      _textEditButton = "Mettre à jour";
      _titleEdit = "Mise à jour";
      print(widget.chanson!.categories);
      tonaliteController.text = widget.chanson!.tonalite;
      titleController.text = widget.chanson!.title;
      descriptionController.text = widget.chanson!.description;
      categoriesController.text = widget.chanson!.categories.join(',');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleEdit),
        actions: [
          IconButton(
            onPressed: () {
              _deleteChanson(context);
            }, 
            icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: tonaliteController,
              decoration: InputDecoration(labelText: 'Tonalité'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: categoriesController,
              decoration: InputDecoration(labelText: 'Catégories (séparées par des virgules)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if(widget.chanson != null) {
                  _updateChanson(context);
                } else {
                  _ajouterNouvelleChanson(context);
                }
                
              },
              child: Text(_textEditButton),
            ),
          ],
        ),
      ),
    );
  }

  void _ajouterNouvelleChanson(BuildContext context) {
    String tonalite = tonaliteController.text.trim();
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    List<String> categories = categoriesController.text.split(',').map((e) => e.trim()).toList();

    Chanson nouvelleChanson = Chanson(
      tonalite: tonalite,
      title: title,
      description: description,
      categories: categories,
    );

    _databaseHelper.insertChanson(nouvelleChanson).then((_) {
      setState(() {});
      Navigator.pop(context); // Revenir à la liste des chansons après l'ajout
    });
  }

  void _updateChanson(BuildContext context) {
    Chanson? chanson = widget.chanson;
    chanson!.title = titleController.text.trim();
    chanson!.tonalite = tonaliteController.text.trim();
    chanson!.description = descriptionController.text.trim();
    chanson!.categories = categoriesController.text.trim().split(', ');

    _databaseHelper.updateChanson(chanson).then((_) {
      setState(() {});
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChansonListScreen())); // Revenir à la liste des chansons après l'ajout
    }).catchError((onError) => print('*****************ERROR'));
  }

  void _deleteChanson(BuildContext context) {
    Chanson? chanson = widget.chanson;

    _databaseHelper.deleteChanson(chanson!).then((_) {
      setState(() {});
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChansonListScreen())); // Revenir à la liste des chansons après l'ajout
    }).catchError((onError) => print('*****************ERROR'));
  }
}
