import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/styles.dart';

class ProfileHeader extends StatefulWidget {
  final Country? selectedCountry;
  const ProfileHeader({super.key, this.selectedCountry});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isNameEditing = false;
  bool _isTitleEditing = false;
  File? _profilePhoto;
  String? _profilePhotoPath;
  SystemUiMode _previousUiMode = SystemUiMode.edgeToEdge;
  Country? _savedCountry; // To store country loaded from SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('userName') ?? '';
      _titleController.text = prefs.getString('userTitle') ?? '';
      _profilePhotoPath = prefs.getString('profilePhoto');
      String? countryCode = prefs.getString('countryCode');
      if (countryCode != null) {
        _savedCountry = Country.tryParse(countryCode);
      }
      if (_profilePhotoPath != null) {
        _profilePhoto = File(_profilePhotoPath!);
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    await prefs.setString('userTitle', _titleController.text);
  }

  Future<void> _saveProfilePhoto(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profilePhoto', path);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      await _cropPhoto(File(pickedFile.path));
    }
  }

  Future<void> _cropPhoto(File photoFile) async {
    _previousUiMode = SystemUiMode.edgeToEdge;
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: photoFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Photo',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          statusBarColor: Colors.black,
          activeControlsWidgetColor: Colors.white,
          dimmedLayerColor: Colors.black.withOpacity(0.5),
          cropFrameColor: Colors.white,
          cropGridColor: Colors.white.withOpacity(0.4),
        ),
        IOSUiSettings(
          title: 'Crop Photo',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: true,
          rotateButtonsHidden: false,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _profilePhoto = File(croppedFile.path);
        _profilePhotoPath = croppedFile.path;
      });
      await _saveProfilePhoto(croppedFile.path);
    }
    await SystemChrome.setEnabledSystemUIMode(_previousUiMode);
  }

  void _showPhotoPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () {
              Navigator.pop(context);
              _pickPhoto(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickPhoto(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required bool isEditing,
    required double fontSize,
    required String placeholder,
    required VoidCallback onEditToggle,
  }) {
    final textStyle = GoogleFonts.orbitron(
      textStyle: TextStyle(fontSize: fontSize, color: Colors.white),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.7,
              child: isEditing
                  ? TextField(
                      controller: controller,
                      style: textStyle,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    )
                  : InkWell(
                      onLongPress: onEditToggle,
                      child: Text(
                        controller.text.isNotEmpty
                            ? controller.text
                            : placeholder,
                        style: textStyle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ),
            const SizedBox(
              width: 5,
              height: 5,
            ),
            if (isEditing)
              IconButton(
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: onEditToggle,
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use widget.selectedCountry if available, otherwise fall back to saved country
    final Country? displayCountry = widget.selectedCountry ?? _savedCountry;

    return Container(
      color: DigicardStyles.accentColor,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10)
          .copyWith(top: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _showPhotoPickerOptions,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 120,
                  backgroundColor: CupertinoColors.white,
                  child: CircleAvatar(
                    radius: 120,
                    backgroundColor: Colors.amberAccent,
                    child: _profilePhoto != null
                        ? ClipOval(
                            child: Image.file(
                              _profilePhoto!,
                              width: 235,
                              height: 235,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 250,
                            color: Colors.amber,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: displayCountry != null
                        ? Text(
                            displayCountry.flagEmoji,
                            style: const TextStyle(fontSize: 30),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: DigicardStyles.accentColor,
                            size: 25,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _nameController,
            isEditing: _isNameEditing,
            fontSize: 14,
            placeholder: 'Your Name',
            onEditToggle: () {
              setState(() {
                if (_isNameEditing) _saveData();
                _isNameEditing = !_isNameEditing;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _titleController,
            isEditing: _isTitleEditing,
            fontSize: 12,
            placeholder: 'Your Designation',
            onEditToggle: () {
              setState(() {
                if (_isTitleEditing) _saveData();
                _isTitleEditing = !_isTitleEditing;
              });
            },
          ),
        ],
      ),
    );
  }
}
