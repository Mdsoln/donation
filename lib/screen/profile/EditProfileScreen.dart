
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../auth/models/auth_model.dart';
import 'module/profile_request.dart';

import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final AuthResponse user;
  final Function(ProfileRequest) onSave;

  const EditProfileScreen({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

final List<String> _genders = ['Select gender', 'Male', 'Female'];
String _selectedGender = 'Select gender';

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _phoneController;
  late TextEditingController _birthDateController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  File? _imageFile;
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _genderController = TextEditingController(text: widget.user.gender);
    _birthDateController = TextEditingController(text: widget.user.dateOfBirth);
    _phoneController = TextEditingController(text: widget.user.mobile);
    _heightController = TextEditingController(text: widget.user.height.toString());
    _weightController = TextEditingController(text: widget.user.weight.toString());
    _imagePath = widget.user.picture;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final request = ProfileRequest(
        fullname: _nameController.text,
        email: _emailController.text,
        gender: _genderController.text,
        phone: _phoneController.text,
        birthdate: _parseBirthDate(_birthDateController.text),
        height: double.tryParse(_heightController.text) ?? 0,
        weight: double.tryParse(_weightController.text) ?? 0,
        profileImage: _imageFile,
      );

      widget.onSave(request);
      Navigator.pop(context);
    }
  }

  DateTime? _parseBirthDate(String text) {
    final formats = [
      DateFormat("dd MMM, yyyy"),       // e.g., "03 Aug, 2002"
      DateFormat("dd MMMM, yyyy"),      // e.g., "03 August, 2002"
      DateFormat("yyyy-MM-dd"),         // in case it's already ISO
    ];

    for (final format in formats) {
      try {
        return format.parseStrict(text);
      } catch (_) {}
    }

    return null; // If all formats fail
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
          ),
        title: const Text(
          "Edit Profile",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imagePath != null
                      ? (_imageFile != null
                      ? FileImage(_imageFile!)
                      : NetworkImage("http://192.168.179.49:8080/images/$_imagePath") as ImageProvider)
                      : null,
                  child: _imagePath == null && _imageFile == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('Full name', _nameController),
              _buildTextField('Email Address', _emailController),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField2<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  hint: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    maxHeight: 180,
                    width: 360, // << control the dropdown width here
                    offset: const Offset(0, -5),
                  ),
                  items: _genders.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(
                        gender,
                        style: TextStyle(
                          color: gender == 'Select gender' ? Colors.grey : Colors.black,
                          fontWeight: gender == 'Select gender' ? FontWeight.w400 : FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                      _genderController.text = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == 'Select gender') {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                ),
              ),
              _buildTextField('Phone number', _phoneController),
              _buildTextField('Date of Birth', _birthDateController),
              Row(
                children: [
                  Expanded(child: _buildTextField('Height', _heightController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Weight', _weightController)),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Save changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}