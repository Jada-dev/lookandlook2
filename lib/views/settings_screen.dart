import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:looknlook/helper/constants.dart';
import 'package:looknlook/helper/dialog_helper.dart';
import 'package:looknlook/views/privacy_policy.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }

  bool isShareEnabled = false;
  bool isCommentEnabled = false;
  bool isLoading = true;
  bool isCommentLoading = true;
  Future<void> _getShareStatus() async {
    try {
      DocumentSnapshot doc = await fireStore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      print(doc.exists);
      if (doc.exists) {
        setState(() {
          isShareEnabled =
              doc['share'] ?? false; // default to false if 'share' is not set
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching share status: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateShareStatus(bool value) async {
    setState(() {
      isShareEnabled = value;
    });

    try {
      await fireStore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'share': value,
      });
    } catch (e) {
      print("Error updating share status: $e");
    }
  }

  Future<void> _getCommentStatus() async {
    try {
      DocumentSnapshot doc = await fireStore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      print(doc.exists);
      if (doc.exists) {
        setState(() {
          isCommentEnabled =
              doc['comment'] ?? false; // default to false if 'share' is not set
          isCommentLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching share status: $e");
      setState(() => isCommentLoading = false);
    }
  }

  Future<void> _updateCommentStatus(bool value) async {
    setState(() {
      isCommentEnabled = value;
    });

    try {
      await fireStore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'comment': value,
      });
    } catch (e) {
      print("Error updating share status: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getShareStatus();
    _getCommentStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildListTile('Privacy', Icons.lock, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TermsWebViewScreen()));
          }),
          _buildListTile('Delete My Data', Icons.delete, () {}),
          _buildListTile('Rate Your Experience', Icons.star_rate, () {}),
          ListTile(
            title: Text(
              "Share",
              style: TextStyle(fontSize: 18),
            ),
            trailing: isLoading
                ? CircularProgressIndicator() // Show loading indicator while fetching data
                : Switch(
                    value: isShareEnabled,
                    onChanged: (value) {
                      _updateShareStatus(value);
                    },
                  ),
          ),
          ListTile(
            title: Text(
              "Comment",
              style: TextStyle(fontSize: 18),
            ),
            trailing: isCommentLoading
                ? CircularProgressIndicator() // Show loading indicator while fetching data
                : Switch(
                    value: isCommentEnabled,
                    onChanged: (value) {
                      _updateCommentStatus(value);
                    },
                  ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                DialogHelper.showLoading();
                authController.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
