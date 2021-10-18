import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_streams_app/common/helpers/cache.dart';
import 'package:live_streams_app/data/model/model.dart';
import 'package:live_streams_app/data/model/person.dart';
import 'package:live_streams_app/data/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PersonRepository {
  PersonRepository({
    CacheClient? cache,
    CollectionReference? person,
    firebase_storage.FirebaseStorage? firebaseStorage,
  })  : _cache = cache ?? CacheClient(),
        _person = person ?? FirebaseFirestore.instance.collection('person'),
        _firebaseStorage =
            firebaseStorage ?? firebase_storage.FirebaseStorage.instance;

  final CacheClient _cache;
  final CollectionReference _person;
  final firebase_storage.FirebaseStorage _firebaseStorage;

  static const userCacheKey = '__user_cache_key__';
  static const personCacheKey = '__person_cache_key__';

  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  Future<Person> getPerson(String id) async {
    try {
      var result = await _person.where("id", isEqualTo: id).get();
      if (result.docs.isNotEmpty && result.docs[0].data() != null) {
        return Person.fromJson(result.docs[0].data() as Map<String, dynamic>);
      } else {
        return Person.empty;
      }
    } on Exception catch (_) {
      return Person.empty;
    }
  }

  Future<void> updatePerson({
    required String id,
    required String firstName,
    required String lastName,
    required String birthDay,
    required String address,
    required String photo,
    required bool verify,
    required bool verifyRequest,
  }) async {
    try {
      if (photo == "") {
        await _person.where("id", isEqualTo: id).get().then(
              (value) => value.docs[0].reference.update(
                {
                  'firstName': firstName,
                  'lastName': lastName,
                  'birthDay': birthDay,
                  'address': address,
                  'verify': verify,
                  'verifyRequest': verifyRequest,
                },
              ),
            );
      } else {
        await _person.where("id", isEqualTo: id).get().then(
              (value) => value.docs[0].reference.update(
                {
                  'firstName': firstName,
                  'lastName': lastName,
                  'birthDay': birthDay,
                  'address': address,
                  'photo': photo,
                  'verify': verify,
                  'verifyRequest': verifyRequest,
                },
              ),
            );
      }
    } on Exception catch (e) {
      return;
    }
  }

  Future<void> uploadFile(String name, String filePath) async {
    File file = File(filePath);

    try {
      await _firebaseStorage.ref('photos/$name').putFile(file);
    } on Exception catch (_) {}
  }

  Future<String> getUrlFile(String photo) async {
    try {
      return await firebase_storage.FirebaseStorage.instance
          .ref('photos/$photo')
          .getDownloadURL();
    } on Exception catch (_) {
      return '';
    }
  }

  //User send to cline
  Future<void> sendFcm(String id, String route, String title, String body,
      {int role = 0}) async {
    final List<String> registrationIds = [];

    if (role == 0) {
      var result = await _person.where("role", isEqualTo: 1).get();
      if (result.docs.isNotEmpty && result.docs[0].data() != null) {
        for (var item in result.docs) {
          final map = item.data() as Map<String, dynamic>;
          final person = Person.fromJson(map);
          if (person.iosToken!.isNotEmpty) {
            registrationIds.add(person.iosToken!);
          }
          if (person.androidToken!.isNotEmpty) {
            registrationIds.add(person.androidToken!);
          }
        }
      }
    } else if (role == 1) {
      var result = await _person.where("id", isEqualTo: id).get();
      if (result.docs.isNotEmpty && result.docs[0].data() != null) {
        final item = result.docs[0];
        final map = item.data() as Map<String, dynamic>;
        final person = Person.fromJson(map);
        if (person.iosToken!.isNotEmpty) {
          registrationIds.add(person.iosToken!);
        }
        if (person.androidToken!.isNotEmpty) {
          registrationIds.add(person.androidToken!);
        }
      }
    }

    var postUrl = "https://fcm.googleapis.com/fcm/send";
    print(registrationIds);
    final data = {
      "registration_ids": registrationIds,
      "notification": {
        "title": title,
        "body": body,
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default",
        "status": "done",
        "id": id,
        "route": route,
      }
    };
    final headers = {
      'Content-type': 'application/json',
      'Authorization':
          'key=AAAALM5B5U4:APA91bFfeQ62nADTxodRdBce_7yoo_9uyJKBtJdcXpwHfzB7L5Gt0Jis6hO2da_NYDcz6owYatOhtciRx2BCwOkFVEc13DaA8a8l4Cj5RizFcdEG3yS_iclbSfM8qAYHexfI6j0BIhHX',
      'Sender': 'id=192438986062'
    };

    BaseOptions options = BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );
    await Dio(options).post(postUrl, data: data);
  }

  Future<void> updateVerify({
    required String id,
    required bool verify,
  }) async {
    try {
      await _person.where("id", isEqualTo: id).get().then(
            (value) => value.docs[0].reference.update(
              {
                'verify': verify,
              },
            ),
          );
    } on Exception catch (_) {
      return;
    }
  }
}
