import 'dart:convert';
import 'dart:io';

import 'package:deliveryapplication_mobile_customer/controller/image_controller.dart';
import 'package:deliveryapplication_mobile_customer/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../ultilities/Constant.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserController userController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  File? profileImage;
  ImageController imageController = Get.put(ImageController());
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (userController.user.value != null) {
      nameController.text = userController.user.value!.fullName;
      emailController.text = userController.user.value!.email;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    if (profileImage != null){
      String? imgUrl = await imageController.uploadImage(profileImage!);
      userController.user.value!.imgUrl = imgUrl!;
    }

    userController.user.value!.fullName = name;
    userController.user.value!.email = email;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =  prefs.getString('jwt_token') ?? '';

    final response = await http.post(
      Uri.parse(Constant.UPDATE_CUSTOMER_URL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "name": name,
        "email": email,
        "imgUrl": userController.user.value!.imgUrl,
      }),
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['code'] == 1000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update successful!')),
        );

      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong, please try again')),
      );
    }


    // userController.user.update((user) {
    //   user?.fullName = name;
    //   user?.email = email;
    //   if (profileImage != null) {
    //     user?.imgUrl = profileImage!.path; // Update image URL for testing
    //   }
    // });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Profile updated successfully!')),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      image: profileImage != null
                          ? DecorationImage(image: FileImage(profileImage!), fit: BoxFit.cover)
                          : (userController.user.value?.imgUrl.isNotEmpty ?? false)
                          ? DecorationImage(
                        image: NetworkImage(
                            Constant.IMG_URL +  userController.user.value!.imgUrl),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: profileImage == null && (userController.user.value?.imgUrl.isEmpty ?? true)
                        ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                      ],
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF39c5c8)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF39c5c8)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: TextEditingController(text: userController.user.value?.phoneNumber),
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF39c5c8)),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39c5c8),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Save',
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
}