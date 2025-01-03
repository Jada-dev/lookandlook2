import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:looknlook/views/home_screen.dart';

import '../helper/constants.dart';

class UpdateImageScreen extends StatelessWidget {
  const UpdateImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed: () {
                Get.off(() => HomeScreen());
              },
              child: const Text(
                'Skip ->',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.orange[700]!, width: 2.5)),
                  padding: const EdgeInsets.all(10),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: firebaseAuth.currentUser!.photoURL.toString(),
                      placeholder: (context, url) => Image.asset(
                        'assets/images/user.png',
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/user.png',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: IconButton(
                    onPressed: () => authController.pickImage(),
                    icon: const Icon(
                      Icons.add_circle_sharp,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
