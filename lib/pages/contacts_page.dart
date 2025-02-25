import 'package:country_picker/country_picker.dart';
import 'package:digi_card/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _githubController = TextEditingController();

  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _titleController.text = prefs.getString('title') ?? '';
      _companyController.text = prefs.getString('company') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _whatsappController.text = prefs.getString('whatsapp') ?? '';
      _linkedinController.text = prefs.getString('linkedin') ?? '';
      _githubController.text = prefs.getString('github') ?? '';
      String? countryCode = prefs.getString('countryCode');
      if (countryCode != null) {
        _selectedCountry = Country.tryParse(countryCode);
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text.trim());
    await prefs.setString('title', _titleController.text.trim());
    await prefs.setString('company', _companyController.text.trim());
    await prefs.setString('email', _emailController.text.trim());
    await prefs.setString('phone', _phoneController.text.trim());
    await prefs.setString('whatsapp', _whatsappController.text.trim());
    await prefs.setString('linkedin', _linkedinController.text.trim());
    await prefs.setString('github', _githubController.text.trim());
    if (_selectedCountry != null) {
      await prefs.setString('countryCode', _selectedCountry!.countryCode);
      await prefs.setString('countryFlag', _selectedCountry!.flagEmoji);
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  void _submitProfile() {
    List<String> errors = [];
    // if (_nameController.text.trim().isEmpty) {
    //   errors.add('Full Name is required');
    // }
    // if (_titleController.text.trim().isEmpty) {
    //   errors.add('Professional Title is required');
    // }
    if (_companyController.text.trim().isEmpty) {
      errors.add('Company Name is required');
    }
    if (_emailController.text.trim().isEmpty) {
      errors.add('Email is required');
    }
    if (_phoneController.text.trim().isEmpty) {
      errors.add('Phone is required');
    }
    if (_whatsappController.text.trim().isEmpty) {
      errors.add('WhatsApp is required');
    }
    if (_selectedCountry == null) {
      errors.add('Country is required');
    }

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errors.join('\n'),
            style: const TextStyle(fontSize: 12.0),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    _saveData().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile submitted and saved successfully',
            style: TextStyle(fontSize: 12.0),
          ),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(8),
        textStyle: const TextStyle(color: Colors.black),
        inputDecoration: const InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: DigicardStyles.textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DigicardStyles.accentColor,
        title: const Text(
          'Professional Profile',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Professional Information',
                style:
                    TextStyle(fontSize: 14, color: DigicardStyles.accentColor),
              ),
              const SizedBox(height: 15),
              // TextField(
              //   controller: _nameController,
              //   decoration: const InputDecoration(
              //     labelText: 'Full Name *',
              //     labelStyle: TextStyle(
              //         color: DigicardStyles.accentColor, fontSize: 12),
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: DigicardStyles.accentColor,
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: DigicardStyles.accentColor),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 8),
              // TextField(
              //   controller: _titleController,
              //   decoration: const InputDecoration(
              //     labelText: 'Professional Title *',
              //     labelStyle: TextStyle(
              //         color: DigicardStyles.accentColor, fontSize: 12),
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(color: DigicardStyles.accentColor),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: DigicardStyles.accentColor),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 8),
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company Name *',
                  labelStyle: TextStyle(
                      color: DigicardStyles.accentColor, fontSize: 12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: DigicardStyles.accentColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: DigicardStyles.accentColor),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showCountryPicker,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: DigicardStyles.accentColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      if (_selectedCountry != null)
                        Text(
                          _selectedCountry!.flagEmoji,
                          style: const TextStyle(fontSize: 18),
                        )
                      else
                        const Icon(Icons.flag,
                            color: DigicardStyles.accentColor),
                      const SizedBox(width: 8),
                      Text(
                        _selectedCountry != null
                            ? _selectedCountry!.name
                            : 'Select Country *',
                        style: TextStyle(
                          color: _selectedCountry != null
                              ? Colors.black
                              : DigicardStyles.accentColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Contact & Links',
                style: TextStyle(
                  fontSize: 14,
                  color: DigicardStyles.accentColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoField('Email *', _emailController, Icons.email,
                  () => _launchUrl('mailto:${_emailController.text}')),
              _buildInfoField('Phone *', _phoneController, Icons.phone, () {}),
              _buildInfoField(
                  'WhatsApp *',
                  _whatsappController,
                  Icons.message,
                  () =>
                      _launchUrl('https://wa.me/${_whatsappController.text}')),
              _buildInfoField('LinkedIn', _linkedinController, Icons.link,
                  () => _launchUrl(_linkedinController.text)),
              _buildInfoField('GitHub', _githubController, Icons.code,
                  () => _launchUrl(_githubController.text)),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DigicardStyles.accentColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 12),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller,
      IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              const TextStyle(color: DigicardStyles.accentColor, fontSize: 12),
          prefixIcon: Icon(icon, color: DigicardStyles.accentColor),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: DigicardStyles.accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: DigicardStyles.accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}
