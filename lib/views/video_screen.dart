import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:looknlook/helper/constants.dart';
import 'package:looknlook/controllers/video_controller.dart';
import 'package:looknlook/views/comment_screen.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:looknlook/views/home_screen.dart';
import 'package:looknlook/views/profile_screen.dart';
import 'package:looknlook/widgets/circle_animation.dart';

import 'package:looknlook/widgets/video_player_iten.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;
  VideoScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final VideoController videoController = Get.put(VideoController());

  final geo = GeoFlutterFire();

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.orange,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  Future<DocumentSnapshot<Object?>?> getShare(String uid) async {
    DocumentSnapshot doc = await fireStore.collection('users').doc(uid).get();

    if (doc.exists) {
      return doc;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(
              initialPage: widget.videoId == "null"
                  ? 0
                  : videoController.videoList.indexWhere(
                      (element) => element.id == widget.videoId,
                    ),
              viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (scontext, index) {
            final data = videoController.videoList[index];

            return Stack(
              children: [
                VideoPlayerItem(
                  videoUrl: data.videoUrl,
                  thumbnail: data.thumbnail,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return ProfileScreen(uid: data.uid);
                                        },
                                      ));
                                    },
                                    child: Text(
                                      data.username,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    data.caption,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.music_note,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        data.songName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: size.height / 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildProfile(
                                  data.profilePhoto,
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          videoController.likeVideo(data.id),
                                      child: Icon(
                                        Icons.favorite,
                                        size: 40,
                                        color: data.likes.contains(
                                                authController.user.uid)
                                            ? Colors.orange[700]
                                            : Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      data.likes.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                FutureBuilder<DocumentSnapshot<Object?>?>(
                                    future: getShare(data.uid),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text("Error fetching data"));
                                      }

                                      return Column(
                                        children: [
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (snapshot
                                                          .data?["comment"] ??
                                                      true)
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CommentScreen(
                                                          id: data.id,
                                                        ),
                                                      ),
                                                    );
                                                },
                                                child: Icon(
                                                  Icons.comment,
                                                  size: 40,
                                                  color: (snapshot.data?[
                                                              "comment"] ??
                                                          true)
                                                      ? Colors.white
                                                      : Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 7),
                                              Text(
                                                data.commentCount.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: (snapshot.data?[
                                                              "comment"] ??
                                                          true)
                                                      ? Colors.white
                                                      : Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (snapshot.data?["share"] ??
                                                      true) {
                                                    Share.share(
                                                        '${data.videoUrl}',
                                                        subject:
                                                            '${data.caption}');
                                                  }
                                                },
                                                child: Transform(
                                                  alignment: Alignment.center,
                                                  transform:
                                                      Matrix4.rotationY(3.14),
                                                  child: Icon(
                                                    Icons.reply,
                                                    size: 40,
                                                    color: (snapshot.data?[
                                                                "share"] ??
                                                            true)
                                                        ? Colors.white
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 7),
                                              Text(
                                                data.shareCount.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: (snapshot
                                                              .data?["share"] ??
                                                          true)
                                                      ? Colors.white
                                                      : Colors.grey,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
