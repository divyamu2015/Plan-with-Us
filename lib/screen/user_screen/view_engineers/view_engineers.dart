import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_construction_pro/constant_page.dart';
import 'package:house_construction_pro/screen/user_screen/request_view/request_view.dart';
import 'package:house_construction_pro/screen/user_screen/view_engineers/bloc/view_engineers_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ViewEngineersProfile extends StatefulWidget {
  final int engineerId;
  final double cent;
  final int workId;
  const ViewEngineersProfile({
    super.key,
    required this.engineerId,
    required this.cent,
    required this.workId,
  });

  @override
  State<ViewEngineersProfile> createState() => _ViewEngineersProfileState();
}

class _ViewEngineersProfileState extends State<ViewEngineersProfile> {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController centController = TextEditingController();
  final TextEditingController sqrftController = TextEditingController();
  final TextEditingController expectedAmountController =
      TextEditingController();
  final TextEditingController additionalAmountController =
      TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController timeDurationController = TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  bool _showAmountDetails = false;
  final List<Feature> _features = [];
  String? profileImageUrl;
  List<String> workProofImageUrls = [];
  final ImagePicker picker = ImagePicker();
  XFile? _profileImage;
  int? engineerId;
  double? cent;
  int? workId;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _getAdditionalFeat();
    engineerId = widget.engineerId;
    cent = widget.cent;
    workId = widget.workId;
    print('Engineer ID in View Engineers Profile: $engineerId');
    print('Cent in View Engineers Profile: $cent');
    print('Work ID in View Engineers Profile: $workId');
    // _features = [
    //   Feature(name: 'Swimming Pool', icon: Icons.pool),
    //   Feature(name: 'Pooja Room', icon: Icons.temple_hindu),
    //   Feature(name: 'Garden', icon: Icons.yard),
    //   Feature(name: 'Gym', icon: Icons.fitness_center),
    // ];

    context.read<ViewEngineersBloc>().add(
      ViewEngineersEvent.getEngineerDetails(
        engineerId: widget.engineerId,
        workId: widget.workId,
      ),
    );
  }

  void _requestDetails() {
    //if (_fromKey.currentState!.validate()) {
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Saved (Future Implementation)')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RequestViewBooking(engineerId: engineerId!);
        },
      ),
    );

    setState(() {
      _isEditing = false; // Exit edit mode after saving
    });
    //  }
  }

  Future<void> _getAdditionalFeat() async {
    try {
      var response = await http.get(Uri.parse(Urlss.getAdditionalfeturi));

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            _features.clear(); // remove old data
            for (var item in data) {
              final name = item['name'] ?? '';

              _features.add(
                Feature(
                  name: name, // comes from backend
                  icon: _getIconForFeature(name), // hardcoded icon mapping
                ),
              );
            }
          });
        }
      } else {
        showError('Failed to load features: ${response.statusCode}');
      }
    } catch (e) {
      showError('Network Error: ${e.toString()}');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Map backend name to icons
  IconData _getIconForFeature(String name) {
    switch (name.toLowerCase()) {
      case 'swimming pool':
        return Icons.pool;
      case 'prayer room':
      case 'pooja room':
        return Icons.temple_hindu;
      case 'garden':
        return Icons.yard;
      case 'gym':
        return Icons.fitness_center;
      case 'study room':
        return Icons.menu_book;
      case 'dressing room':
        return Icons.checkroom;
      case 'makeup room':
        return Icons.brush;
      case 'home office':
        return Icons.home_work;
      case 'well':
        return Icons.water;
      default:
        return Icons.home; // fallback icon
    }
  }

  void _toggleAmountDetails() {
    setState(() {
      _showAmountDetails = !_showAmountDetails;
    });
  }

  Widget _buildFeatureCard(Feature feature) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(feature.icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(feature.name, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Checkbox(
            value: feature.isSelected,
            onChanged: (value) {
              setState(() {
                feature.isSelected = value!;
              });
            },
            fillColor: WidgetStateProperty.all(Colors.green),
          ),
        ],
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _profileImage = pickedFile;
          profileImageUrl = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProfileImagePicker() {
    final double size = 150;
    if (_profileImage != null) {
      return GestureDetector(
        onTap: _pickProfileImage,
        child: CircleAvatar(
          radius: size / 2,
          backgroundImage: FileImage(File(_profileImage!.path)),
        ),
      );
    } else if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: _pickProfileImage,
        child: CircleAvatar(
          radius: size / 2,
          backgroundImage: NetworkImage(
            'https://417sptdw-8001.inc1.devtunnels.ms$profileImageUrl',
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: _pickProfileImage,
        child: CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.camera_alt, size: 50, color: Colors.white70),
        ),
      );
    }
  }

  Widget _buildFeatureChip(Feature feature) {
    return FilterChip(
      label: Text(feature.name),
      avatar: Icon(feature.icon, size: 20),
      selected: feature.isSelected,
      onSelected: (selected) {
        setState(() {
          feature.isSelected = selected;
        });
      },
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _fromKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildProfileImagePicker()),
            const SizedBox(height: 30),
            TextFormField(
              controller: projectNameController,
              decoration: const InputDecoration(
                labelText: 'Project Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: centController,
              decoration: const InputDecoration(
                labelText: 'Cent',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: sqrftController,
              decoration: const InputDecoration(
                labelText: 'Square Feet',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: _toggleAmountDetails,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.shade50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Amount Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      _showAmountDetails
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
            if (_showAmountDetails) ...[
              const SizedBox(height: 10),
              TextFormField(
                controller: expectedAmountController,
                decoration: const InputDecoration(
                  labelText: 'Expected Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: additionalAmountController,
                decoration: const InputDecoration(
                  labelText: 'Additional Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: totalAmountController,
                decoration: const InputDecoration(
                  labelText: 'Total Amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 30),
            Text(
              'Additional Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 72, 5, 83),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _features.length,
                itemBuilder: (context, index) {
                  return _buildFeatureCard(_features[index]);
                },
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: timeDurationController,
              decoration: const InputDecoration(
                labelText: 'Time Duration',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text(
                  'REQUEST BOOKING',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onPressed: _requestDetails,
                // () {
                // if (_fromKey.currentState!.validate()) {
                //  _requestDetails();
                // }
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Registration successful!'),
                //     backgroundColor: Colors.green,
                //   ),
                // );
                // Navigator.pop(context);
                // },
                // () {

                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Booking functionality not implemented.'),
                //     ),
                //   );
                // },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Project Bio")),
      body: BlocBuilder<ViewEngineersBloc, ViewEngineersState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('No data')),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (response) {
              profileImageUrl = response.propertyImage;
              workProofImageUrls = response.images;

              projectNameController.text = response.projectName;
              centController.text = response.cent;
              sqrftController.text = response.squarefeet;
              expectedAmountController.text = response.expectedAmount;
              additionalAmountController.text = response.additionalAmount;
              totalAmountController.text = response.totalAmount;
              timeDurationController.text = response.timeDuration;

              for (var feature in _features) {
                feature.isSelected = response.additionalFeatures.contains(
                  feature.name,
                );
              }

              return _buildForm();
            },
            error: (error) => Center(child: Text('Error: $error')),
          );
        },
      ),
    );
  }
}

class Feature {
  String name;
  IconData icon;
  bool isSelected;
  Feature({required this.name, required this.icon, this.isSelected = false});
}
