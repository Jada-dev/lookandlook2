import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:looknlook/controllers/auth_controller.dart';
import 'package:looknlook/views/add_video_screen.dart';
import 'package:looknlook/views/chat_screen.dart';
import 'package:looknlook/views/profile_screen.dart';
import 'package:looknlook/views/search_screen.dart';
import 'package:looknlook/views/video_screen.dart';

// COLORS
const backgroundColor = Colors.white;
var buttonColor = Colors.orange[700];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var fireStore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
