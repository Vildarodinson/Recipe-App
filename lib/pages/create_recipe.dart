import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/pages/navbar.dart';
import 'package:recipe_app/widgets/color.dart';
import 'package:path/path.dart' as path;



class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  File? pickedFile; // Store the picked file
  UploadTask? uploadTask;
  bool isFilePicked = false; // Track whether a file is already picked

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Specify the file type as an image
    );

    if (result != null) {
      setState(() {
        pickedFile = File(result.files.single.path!); // Store the picked file
        isFilePicked = true; // Set the flag to true
      });
    }
  }

  Future uploadFile() async {
    if (!isFilePicked) {
      // No file selected
      return;
    }

    final fileName = _name!.toLowerCase().replaceAll(' ', '') + '.jpg'; // New file name
    final filePath = 'recipe_images/$fileName';

    final ref = FirebaseStorage.instance.ref().child(filePath);
    setState(() {
      uploadTask = ref.putFile(pickedFile!);
    });

    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    setState(() {
      uploadTask = null;
    });

    setState(() {
      isFilePicked = false; // Reset the flag after successful upload
    });
  }

  final _formKey = GlobalKey<FormState>();
  String? _name;
  num? _time;
  String? _timetype;
  int? _serving;
  String? _difficulty;
  int? _calories;
  List<String> _ingredients = [];
  List<num> _ingredientAmounts = [];
  List<TextEditingController> _ingredientControllers = [];
  List<TextEditingController> _amountControllers = [];
  List<String> _directions = [];
  List<TextEditingController> _directionControllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColor.AppBack,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Recipe Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the time';
                  }
                  return null;
                },
                onSaved: (value) {
                  _time = double.tryParse(value ?? '') ?? 0;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Time Type'),
                value: _timetype,
                items: const [
                  DropdownMenuItem(value: 'u', child: Text('Hours')),
                  DropdownMenuItem(value: 'min', child: Text('Minutes')),
                ],
                onChanged: (value) {
                  setState(() {
                    _timetype = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Serving'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the serving';
                  }
                  return null;
                },
                onSaved: (value) {
                  _serving = int.tryParse(value ?? '') ?? 0;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Difficulty'),
                value: _difficulty,
                items: const [
                  DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                ],
                onChanged: (value) {
                  setState(() {
                    _difficulty = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a difficulty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calories'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the calories';
                  }
                  return null;
                },
                onSaved: (value) {
                  _calories = int.tryParse(value ?? '') ?? 0;
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Ingredients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _ingredients.length,
                itemBuilder: (context, index) => _buildIngredientForm(index),
              ),
              ElevatedButton(
                onPressed: _addIngredientForm,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: Text('Add Ingredient'),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Directions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _directions.length,
                itemBuilder: (context, index) => _buildDirectionForm(index),
              ),
              ElevatedButton(
                onPressed: _addDirectionForm,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: const Text('Add Direction'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: selectFile,
                  child: const Text('Select File')),
              const SizedBox(height: 16.0),
              if (pickedFile != null)
                Container(
                  height: 300, // Adjust the height as needed
                  child: Center(
                    child: pickedFile!.path != null
                        ? Image.file(
                      File(pickedFile!.path!),
                      width: 400,
                      fit: BoxFit.cover,
                    )
                        : const SizedBox(),
                  ),
                ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save(); // Save the form field values

                    if (pickedFile != null) {
                      await uploadFile(); // Upload the file
                    }
                  }
                },
                child: const Text('Upload File'),
              ),
              const SizedBox(height: 16),
              buildProgress(),
              const SizedBox(height: 16.0),
              Text("Please Upload File Before Saving Recipe"),
              ElevatedButton(
                onPressed: _savingRecipe ? null : () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveRecipe();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: const Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }

  Widget buildProgress() => StreamBuilder(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot){
        if (snapshot.hasData){
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColor.AppBack,
                  color: AppColor.AppBack,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        }
        else{
          return const SizedBox(height: 30);
        }
      });

  Widget _buildIngredientForm(int index) {
    final ingredientController = TextEditingController();
    final amountController = TextEditingController();

    // ValueNotifier to track ingredient value
    final ingredientValueNotifier = ValueNotifier<String>(_ingredients[index]);
    // ValueNotifier to track amount value
    final amountValueNotifier = ValueNotifier<String>(
        _ingredientAmounts[index].toString());

    // Update the ingredient value in the list whenever it changes
    ingredientValueNotifier.addListener(() {
      _ingredients[index] = ingredientValueNotifier.value;
    });

    // Update the amount value in the list whenever it changes
    amountValueNotifier.addListener(() {
      _ingredientAmounts[index] =
          double.tryParse(amountValueNotifier.value) ?? 0;
    });

    // Set the initial ingredient and amount values
    ingredientController.text = _ingredients[index];
    amountController.text = _formatAmountValue(
        _ingredientAmounts[index]); // Format the amount value

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: ingredientController,
            decoration: const InputDecoration(labelText: 'Ingredient'),
            onChanged: (value) => ingredientValueNotifier.value = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an ingredient';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            controller: amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount'),
            onChanged: (value) => amountValueNotifier.value = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () => _removeIngredientForm(index),
          icon: Icon(Icons.remove_circle),
          color: Colors.red,
        ),
      ],
    );
  }

  String _formatAmountValue(num value) {
    if (value == value.round()) {
      return value.round().toString();
    } else {
      return value.toStringAsFixed(1);
    }
  }

  void _addIngredientForm() {
    setState(() {
      final ingredientController = TextEditingController();
      final amountController = TextEditingController();

      // Add the new TextEditingController instances to the list
      _ingredientControllers.add(ingredientController);
      _amountControllers.add(amountController);

      // Add initial values for the new ingredient and amount fields
      _ingredients.add('');
      _ingredientAmounts.add(0);
    });
  }

  void _removeIngredientForm(int index) {
    setState(() {
      // Remove the TextEditingController instances from the list
      _ingredientControllers.removeAt(index);
      _amountControllers.removeAt(index);

// Remove the ingredient and amount values from the lists
      _ingredients.removeAt(index);
      _ingredientAmounts.removeAt(index);
    });
  }

  Widget _buildDirectionForm(int index) {
    final directionController = TextEditingController();

    // ValueNotifier to track direction value
    final directionValueNotifier = ValueNotifier<String>(_directions[index]);

    // Update the direction value in the list whenever it changes
    directionValueNotifier.addListener(() {
      _directions[index] = directionValueNotifier.value;
    });

    // Set the initial direction value
    directionController.text = _directions[index];

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: directionController,
            decoration: const InputDecoration(labelText: 'Direction'),
            onChanged: (value) => directionValueNotifier.value = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a direction';
              }
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () => _removeDirectionForm(index),
          icon: Icon(Icons.remove_circle),
          color: Colors.red,
        ),
      ],
    );
  }

  void _addDirectionForm() {
    setState(() {
      final directionController = TextEditingController();

      // Add the new TextEditingController instance to the list
      _directionControllers.add(directionController);

      // Add initial value for the new direction field
      _directions.add('');
    });
  }

  void _removeDirectionForm(int index) {
    setState(() {
      // Remove the TextEditingController instance from the list
      _directionControllers.removeAt(index);

      // Remove the direction value from the list
      _directions.removeAt(index);
    });
  }

  bool _savingRecipe = false; // Track whether the recipe is being saved

  Future<void> _saveRecipe() async {
    if (_savingRecipe) {
      return; // Prevent multiple save operations
    }

    setState(() {
      _savingRecipe = true;
    });

    try {
      final recipeData = {
        'name': _name,
        'time': _time,
        'timetype': _timetype,
        'serving': _serving,
        'difficulty': _difficulty,
        'cal': _calories,
      };

      final recipeRef = await FirebaseFirestore.instance.collection('recipes')
          .add(recipeData);
      final ingredientsRef = recipeRef.collection('Ingredients').doc(
          'Ingredients');
      final amountsRef = recipeRef.collection('ingredientAmounts').doc(
          'ingredientAmounts');
      final directionsRef = recipeRef.collection('Directions').doc(
          'Directions');

      final Map<String, dynamic> ingredientData = {};
      final Map<String, dynamic> amountData = {};
      final Map<String, dynamic> directionData = {};

      for (int i = 0; i < _ingredients.length; i++) {
        ingredientData['Ingredient${i + 1}'] = _ingredients[i];
        amountData['Amount${i + 1}'] = _ingredientAmounts[i];
      }

      for (int i = 0; i < _directions.length; i++) {
        directionData['Direction${i + 1}'] = _directions[i];
      }

      await ingredientsRef.set(ingredientData);
      await amountsRef.set(amountData);
      await directionsRef.set(directionData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe saved successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save recipe: $error')),
      );
    } finally {
      setState(() {
        _savingRecipe = false;
      });
    }
  }
}