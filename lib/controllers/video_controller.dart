import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:looknlook/helper/constants.dart';
import 'package:looknlook/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() async {
    super.onInit();
    Position position = await _getCurrentLocation();
    double lat = position.latitude;
    double lng = position.longitude;

    // _videoList.bindStream(
    //   GeoFlutterFire()
    //       .collection(collectionRef: fireStore.collection('videos'))
    //       .within(
    //         center: GeoFirePoint(lat, lng),
    //         radius: 10,
    //         field: 'location',
    //         strictMode: true,
    //       )
    //       .map((List<DocumentSnapshot> documentList) {
    //     List<Video> retVal = [];
    //     for (var doc in documentList) {
    //       retVal.add(Video.fromSnap(doc));
    //     }
    //     return retVal;
    //   }),
    // );

    _videoList.bindStream(
      fireStore.collection('videos').snapshots().map((QuerySnapshot query) {
        List<Video> videoList =
            query.docs.map((doc) => Video.fromSnap(doc)).toList();

        // Sort videoList by calculated distance without adding it to Video instances
        videoList.sort((a, b) {
          GeoPoint locationA =
              a.location; // Assuming Video has a location getter
          GeoPoint locationB = b.location;

          double distanceA = Geolocator.distanceBetween(
            lat,
            lng,
            locationA.latitude,
            locationA.longitude,
          );
          double distanceB = Geolocator.distanceBetween(
            lat,
            lng,
            locationB.latitude,
            locationB.longitude,
          );

          return distanceA.compareTo(distanceB);
        });

        return videoList;
      }),
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show an error
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show an error
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, show an error
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current location
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  likeVideo(String id) async {
    DocumentSnapshot doc = await fireStore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await fireStore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await fireStore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
