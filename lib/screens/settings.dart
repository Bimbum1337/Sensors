import 'package:flutter/material.dart';

import '../utils/colors_manager.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _height;
  int? _weight;
  Gender? _gender;
  int? _age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Name',
                  style: TextStyle(
                      fontSize: 16.0, color: ColorsManager.primaryText),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Height (in cm)',
                  style: TextStyle(
                      fontSize: 16.0, color: ColorsManager.primaryText),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _height = int.tryParse(value!);
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Weight (in kg)',
                  style: TextStyle(
                      fontSize: 16.0, color: ColorsManager.primaryText),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weight = int.tryParse(value!);
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Gender',
                  style: TextStyle(
                      fontSize: 16.0, color: ColorsManager.primaryText),
                ),
                DropdownButtonFormField<Gender>(
                  value: _gender,
                  items: [
                    DropdownMenuItem(
                      child: Text('Male'),
                      value: Gender.male,
                    ),
                    DropdownMenuItem(
                      child: Text('Female'),
                      value: Gender.female,
                    ),
                  ],
                  validator: (value) {
                    if (value == null) {
                      return 'Please choose your gender';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  onSaved: (value) {
                    _gender = value!;
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Age',
                  style: TextStyle(
                      fontSize: 16.0, color: ColorsManager.primaryText),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _age = int.tryParse(value!);
                  },
                ),
                SizedBox(height: 32.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Do something with the user input data
                        print('Name: $_name');
                        print('Height: $_height');
                        print('Weight: $_weight');
                        print('Gender: $_gender');
                        print('Age: $_age');
                      }
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Gender { male, female }
