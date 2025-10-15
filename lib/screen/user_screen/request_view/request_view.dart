import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:house_construction_pro/screen/user_screen/request_view/request_model.dart';
import 'package:house_construction_pro/screen/user_screen/terms_condition/terms_condition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:http/http.dart' as http;

class RequestViewBooking extends StatefulWidget {
  const RequestViewBooking({super.key,required this.engineerId});
  final int engineerId ;

  @override
  State<RequestViewBooking> createState() => _RequestViewBookingState();
}

class _RequestViewBookingState extends State<RequestViewBooking> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController centCtrl = TextEditingController();
  TextEditingController sqftCtrl = TextEditingController();
  TextEditingController expectedAmountCtrl = TextEditingController();
  TextEditingController featuresCtrl = TextEditingController();
  File? _image;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<GetEngineerProfileModel> _getData() async {
    final url = Uri.parse(
      "https://417sptdw-8001.inc1.devtunnels.ms/userapp/engineer/profile/1/",
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return GetEngineerProfileModel.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to load profile. Status code: ${response.statusCode}',
      );
    }
  }

  Future<void> _selectDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<GetEngineerProfileModel>(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No data found"));
          }

          final profile = snapshot.data!;

          // Pre-fill controllers with API data
          // nameCtrl.text = profile.n
          // phoneCtrl.text = profile.phone;
          // addressCtrl.text = profile.address;
          nameCtrl.text = profile.name;
          phoneCtrl.text = profile.phone;
          addressCtrl.text = profile.address;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 36.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "Request Form",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildTextField(nameCtrl, "Name", readOnly: true),
                        _buildTextField(
                          phoneCtrl,
                          "Phone",
                          keyboardType: TextInputType.phone,
                          readOnly: true,
                        ),
                        _buildTextField(addressCtrl, "Address", readOnly: true),
                        // _buildTextField(
                        //   centCtrl,
                        //   "Cent",
                        //   keyboardType: TextInputType.number,
                        // ),
                        // _buildTextField(
                        //   sqftCtrl,
                        //   "Square Feet",
                        //   keyboardType: TextInputType.number,
                        // ),
                        // _buildTextField(
                        //   expectedAmountCtrl,
                        //   "Expected Amount",
                        //   keyboardType: TextInputType.number,
                        // ),
                        // _buildTextField(
                        //   featuresCtrl,
                        //   "Addition Features",
                        //   maxLines: 2,
                        // ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _datePickerField(
                                "Start Date",
                                _startDate,
                                () => _selectDate(true),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _datePickerField(
                                "End Date",
                                _endDate,
                                () => _selectDate(false),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: pickImage,
                              icon: Icon(Icons.upload_file),
                              label: Text('Upload Suggestion'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(width: 12),
                            _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      _image!,
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(height: 32),
                        SwipeButton.expand(
                          thumb: Icon(Icons.double_arrow, color: Colors.white),
                          activeThumbColor: Colors.deepPurple,
                          activeTrackColor: Colors.deepPurple.shade100,
                          onSwipe: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Request Submitted!")),
                            );
                            // if (_formKey.currentState?.validate() ?? false) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(content: Text("Request Submitted!")),
                            //   );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return TermsandCondition();
                                },
                              ),
                            );
                            // Do further submit or processing here
                            //                       }
                          },
                          child: Text(
                            "BOOK NOW",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          fillColor: Colors.white.withOpacity(0.9),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        // validator: (val) {
        //   if (val == null || val.isEmpty) return "Required";
        //   return null;
        // },
      ),
    );
  }

  Widget _datePickerField(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurple.shade100),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: Colors.deepPurple),
            SizedBox(width: 10),
            Text(
              date != null ? "${date.day}/${date.month}/${date.year}" : label,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
