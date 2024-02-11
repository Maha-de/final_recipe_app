import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchDemo extends StatefulWidget {
  @override
  _SearchDemoState createState() => _SearchDemoState();
}

class _SearchDemoState extends State<SearchDemo> {
  final TextEditingController _controller = TextEditingController();
  List<DocumentSnapshot> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('recipes').get();
    setState(() {
      _data = snapshot.docs;
    });
  }

  void _filterData(String query) {
    final List<DocumentSnapshot> filteredData = _data.where((doc) {
      final String name = doc['title'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _data = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search...',
          ),
          onChanged: _filterData,
        ),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final DocumentSnapshot doc = _data[index];
          return ListTile(
            title: Text(doc['title']),
            subtitle: Text(doc['description']),
          );
        },
      ),
    );
  }
}