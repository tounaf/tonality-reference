// chanson_list_screen.dart
import 'package:flutter/material.dart';
import 'package:song/component/chanson_edit.dart';
import 'package:song/model/chanson.dart';
import 'package:song/db/database_helper.dart';

class ChansonListScreen extends StatefulWidget {
  @override
  _ChansonListScreenState createState() => _ChansonListScreenState();
}

class _ChansonListScreenState extends State<ChansonListScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController _searchController = TextEditingController();

  List<Chanson> _chansons = []; // Liste des chansons filtrées

  @override
  void initState() {
    super.initState();
    _getChansons(); // Charger toutes les chansons initialement
  }

  Future<void> _getChansons() async {
    print("================ new list ================");
    // Récupérer toutes les chansons depuis la base de données
    List<Chanson> chansons = await _databaseHelper.getChansons();
    setState(() {
      _chansons = chansons; // Mettre à jour la liste des chansons
    });
  }

  Future<void> _searchChansons(String searchTerm) async {
    // Filtrer les chansons en fonction du terme de recherche
    List<Chanson> chansons = await _databaseHelper.searchChansonsByTitle(searchTerm);
    setState(() {
      _chansons = chansons; // Mettre à jour la liste des chansons
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher par titre...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            _searchChansons(value);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Naviguer vers la page de création d'une nouvelle chanson
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new ChansonEditScreen(null)),
              ).then((_) {
                // Rafraîchir la liste après le retour de la page de création
                _getChansons();
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chansons.length,
        itemBuilder: (context, index) {
          Chanson chanson = _chansons[index];
          return ListTile(
            leading: Icon(Icons.music_note),
            title: Text(chanson.title),
            subtitle: Text('Tonalité: ${chanson.tonalite}'),
            onTap: () => {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => new ChansonEditScreen(chanson))
              )
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers la page de création d'une nouvelle chanson
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new ChansonEditScreen(null)),
          ).then((_) {
            // Rafraîchir la liste après le retour de la page de création
            _getChansons();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
