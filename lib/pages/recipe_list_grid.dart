import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/grid_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeGrid extends StatefulWidget {
  @override
  State<RecipeGrid> createState() => _RecipeGridState();
}

class _RecipeGridState extends State<RecipeGrid> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading...");

        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
        final itemCount = documents.length;

        return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final doc = documents[index];
            return RecipeCard(recipes: doc);
          },
        );
      },
    );
  }
}
