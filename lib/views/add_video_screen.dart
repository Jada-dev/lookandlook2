// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tiktok_tutorial/helper/constants.dart';
// import 'package:tiktok_tutorial/views/confirm_screen.dart';

// class AddVideoScreen extends StatelessWidget {
//   const AddVideoScreen({Key? key}) : super(key: key);

//   Future<void> pickVideo(ImageSource src, BuildContext context) async {
//     try {
//       final video = await ImagePicker().pickVideo(source: src);

//       print('Video picked: $video');

//       if (video != null) {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => ConfirmScreen(
//               videoFile: File(video.path),
//               videoPath: video.path,
//             ),
//           ),
//         );
//       } else {
//         print('No video selected.');
//       }
//     } catch (e) {
//       print('Error picking video: $e');
//     }
//   }

//   showOptionsDialog(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (context) => SimpleDialog(
//         backgroundColor: Colors.white,
//         children: [
//           SimpleDialogOption(
//             onPressed: () => pickVideo(ImageSource.gallery, context),
//             child: Row(
//               children: const [
//                 Icon(
//                   Icons.image,
//                   color: Colors.black,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(7.0),
//                   child: Text(
//                     'Gallery',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SimpleDialogOption(
//             onPressed: () => pickVideo(ImageSource.camera, context),
//             child: Row(
//               children: const [
//                 Icon(
//                   Icons.camera_alt,
//                   color: Colors.black,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(7.0),
//                   child: Text(
//                     'Camera',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SimpleDialogOption(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Row(
//               children: const [
//                 Icon(
//                   Icons.cancel,
//                   color: Colors.black,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(7.0),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: InkWell(
//           onTap: () => showOptionsDialog(context),
//           child: Container(
//             width: 190,
//             height: 50,
//             decoration: BoxDecoration(color: buttonColor),
//             child: const Center(
//               child: Text(
//                 'Add Video',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_tutorial/helper/constants.dart';
import 'package:tiktok_tutorial/views/confirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  Future<void> pickVideo(ImageSource src, BuildContext context) async {
    try {
      final video = await ImagePicker().pickVideo(source: src);

      if (video != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConfirmScreen(
              videoFile: File(video.path),
              videoPath: video.path,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error picking video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.only(right: 30, bottom: 40),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Camera Icon
              GestureDetector(
                onTap: () => pickVideo(ImageSource.camera, context),
                child: Container(
                  decoration: BoxDecoration(
                    color: buttonColor, // Red background for camera icon
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: Colors.white, width: 2), // White border
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 60), // Space between icons

              // Gallery Icon
              GestureDetector(
                onTap: () => pickVideo(ImageSource.gallery, context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .grey.shade200, // Light background for gallery icon
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(8),
                  child:  Icon(
                    Icons.photo_library, // Gallery icon
                    color: Colors.grey[700],
                    size: 30,
                  ),
                ),
              ),
               const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
