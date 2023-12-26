// nouvelle_chanson_screen.dart
import 'package:flutter/material.dart';
import 'package:song/model/chanson.dart';
import 'package:song/db/database_helper.dart';

class ChansonEditScreen extends StatefulWidget {
  @override
  _ChansonEditScreenState createState() => _ChansonEditScreenState();
}

class _ChansonEditScreenState extends State<ChansonEditScreen> {
  final TextEditingController tonaliteController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Chanson'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: tonaliteController,
              decoration: InputDecoration(labelText: 'Tonalité'),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre'),
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
              onPressed: () => _ajouterNouvelleChanson(context),
              child: Text('Ajouter Chanson'),
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
}
