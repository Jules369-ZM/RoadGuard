// ignore_for_file: comment_references, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auth_repo/auth_repo.dart';
import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_data/local_data.dart';
import 'package:net_source/net_source.dart';
import 'package:path/path.dart';

/// {@template firebase_repo}
/// For firebase function
/// {@endtemplate}
class FirebaseRepo {
  /// {@macro firebase_repo}
  FirebaseRepo({
    required LocalData db,
    required SharedPrefs prefs,
    required NetSource net,
    required firebase_auth.FirebaseAuth? firebaseAuth,
    required GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
    CacheClient? cache,
    FirebaseStorage? firebaseStorage,
  })  : _db = db,
        _prefs = prefs,
        _net = net,
        _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final LocalData _db;
  final SharedPrefs _prefs;
  // ignore: unused_field
  final NetSource _net;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final CacheClient _cache;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  // Shared preferences keys
  final String _keyId = 'user_id';
  final String _keyToken = 'token';
  final String _keyLoggedIn = 'logged_in';
  // table names
  final String _tblUsers = 'users';
  final _controller = StreamController<AuthStatus>.broadcast();

  ///
  Stream<AuthStatus> get authStatus async* {
    // final isLoggedIn = await _checkLoggedIn();
    // if (isLoggedIn) {
    // yield AuthStatus.authenticated;
    // } else {
    // yield AuthStatus.unauthenticated;
    // }
    yield* _controller.stream;
  }

  /// Whether or not the current environment is web
  /// Should only be overridden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Checks if a user with the given [uid] exists in Firestore.
  ///
  /// Returns [true] if the user is new, [false] otherwise.
  ///
  /// Used to determine if a user is new or not, this function is critical
  /// for the login flow as it ensures that the user data is not overwritten
  /// if the user logs in again.
// /******  e7038d47-3c8c-4566-814c-c7a6755941ff  *******/
  Future<bool> isNewUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return !doc.exists; // If no document, it's a new user
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Handles the user login flow.
  ///
  /// If the user is new, adds them to Firestore.
  /// If the user is not new, does nothing.
  ///
  /// Used to determine if a user is new or not, this function is critical
  /// for the login flow as it ensures that the user data is not overwritten
  /// if the user logs in again.
// /******  edd50996-3367-4a05-b77b-fec94f4ba4db  *******/
  Future<void> handleUserLogin(User user) async {
    final isNew = await isNewUser(user.id!);
    if (isNew) {
    } else {}
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Listens for changes in the authentication state of the user.
  ///
  /// If a user is authenticated, adds [AuthStatus.authenticated] to the stream.
  /// If the user is anonymous, adds [AuthStatus.guest] to the stream.
  /// If an error occurs, logs the error and adds [AuthStatus.unauthenticated]
  /// to the stream.

// /******  64afe51b-c397-4b68-808b-e5ace61a8cae  *******/
  Future<void> listenForUser() async {
    try {
      _firebaseAuth.authStateChanges().listen((firebaseUser) async {
        log('firebaseUser: $firebaseUser');
        if (firebaseUser != null) {
          final userCred = firebaseUser;
          final fireStoreUser = await getUserDataFromFirestore(userCred.uid);
          log('fireStoreUser: $fireStoreUser');
          if (fireStoreUser != null) {
            final user = User.fromJson(fireStoreUser);
            final t = await userCred.getIdToken();
            await _prefs.set(_keyToken, t);
            await _prefs.set(_keyLoggedIn, true);
            await _prefs.set(_keyId, user.id);
            await _db.insertOne(_tblUsers, user.toJsonDb());
            _controller.add(AuthStatus.authenticated);
          } else {
            _controller.add(AuthStatus.unauthenticated);
          }
        } else if (firebaseUser != null && firebaseUser.isAnonymous) {
          _controller.add(AuthStatus.guest);
        } else {
          _controller.add(AuthStatus.unauthenticated);
        }
      });
    } catch (e) {
      log('Error in listenForUser: $e');
      _controller.add(AuthStatus.unauthenticated);
    }
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String metaData,
    required String role,
  }) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userCred = cred.user!;
      final user = User(
        id: userCred.uid,
        email: userCred.email ?? email,
        name: userCred.displayName ?? name,
        avatar: userCred.photoURL,
        phone: userCred.phoneNumber ?? phone,
        role: role,
        metaData: jsonEncode({
          'emailVerified': userCred.emailVerified,
          'providerId': userCred.providerData[0].providerId,
          'uid': userCred.providerData[0].uid,
          'displayName': userCred.providerData[0].displayName,
          'photoUrl': userCred.providerData[0].photoURL,
          'email': userCred.providerData[0].email,
          'phoneNumber': userCred.providerData[0].phoneNumber,
          'provider': userCred.providerData[0].providerId,
          'metaData1': metaData,
        }),
      );
      await saveUserDataToFirestore(user: user.toJson());
    } on firebase_auth.FirebaseAuthException catch (e) {
      log('Error in signUp: $e');
      log('Error in signUp: ${e.code}');
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      log('Error in signUp: $e');
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Save user data to Firestore after registration
  Future<void> saveUserDataToFirestore({
    required JsonMap user,
  }) async {
    try {
      user['createdAt'] = FieldValue.serverTimestamp();
      final uid = user['id'] as String;
      log('Saving user data: $user');
      await _firestore.collection('users').doc(uid).set(user);
    } catch (e) {
      log('Error saving user data: $e');
      // throw Exception('Error saving user data: $e');
    }
  }

  /// Get user details from Firestore
  Future<Map<String, dynamic>?> getUserDataFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      final cred = await _firebaseAuth.signInWithCredential(credential);
      final userCred = cred.user!;
      final user = User(
        id: userCred.uid,
        email: userCred.email ?? '',
        name: userCred.displayName ?? '',
        avatar: userCred.photoURL,
        phone: userCred.phoneNumber ?? '',
        role: 'DRIVER',
        metaData: jsonEncode({
          'emailVerified': userCred.emailVerified,
          'providerId': userCred.providerData[0].providerId,
          'uid': userCred.providerData[0].uid,
          'displayName': userCred.providerData[0].displayName,
          'photoUrl': userCred.providerData[0].photoURL,
          'email': userCred.providerData[0].email,
          'phoneNumber': userCred.providerData[0].phoneNumber,
          'provider': userCred.providerData[0].providerId,
          'metaData1': '',
        }),
      );
      await saveUserDataToFirestore(user: user.toJson());
    } on firebase_auth.FirebaseAuthException catch (e) {
      log('Error in logInWithGoogle 1: ${e.code}');
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (e) {
      log('Error in logInWithGoogle: $e');
      throw const LogInWithGoogleFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      log('Error in logInWithEmailAndPassword: ${e.code}');
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      // log('Error in logInWithEmailAndPassword first: $e');
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [firebase_auth.User] from the [] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Adds a new document to the given [collectionPath] with the given [id].
  ///
  /// The document data is given by [data] and must be a JSON-encodable map.
  ///
  /// If the document already exists, its data will be overwritten.
  ///
  /// If an exception occurs, it is logged and swallowed.
// /******  8d8de945-5052-4d94-b6de-f797a6f2e7a7  *******/
  FutureOr<void> addDocument(
    JsonMap data,
    String collectionPath,
    String id,
  ) async {
    try {
      final docCollectionRef = _firestore.collection(collectionPath).doc(id);
      await docCollectionRef.set(data);
    } on Exception catch (e) {
      log('Error in addDocument: $e');
    }
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Reads all documents from Firestore based on the provided collection path.
  ///
  /// Fetches all documents from Firestore based on the provided
  /// [collectionPath].
  /// Returns a [Stream] of [List] containing the documents as [JsonMap].
  ///
  /// Throws an error if an exception occurs.
// /******  174756ce-bff8-4514-979f-a1fcf1361473  *******/
  Stream<List<JsonMap>> readDocuments({required String collectionPath}) =>
      _firestore.collection(collectionPath).snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => doc.data()).toSet().toList(),
          );

/*************  ✨ Codeium Command ⭐  *************/
  /// Reads documents from Firestore based on the provided status.
  ///
  /// Fetches documents from Firestore filtered by the provided [status].
  /// Returns a list of [JsonMap] containing the documents.
  ///
  /// Throws an error if an exception occurs.
// /******  e3979b43-14a7-4f33-84a0-bb08a9be3bb3  *******/
  Future<List<JsonMap>> readDocumentsByStatus({
    required String collectionPath,
    required String status,
  }) async {
    try {
      // Fetch documents from Firestore based on the status
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionPath)
          .where('status', isEqualTo: status) // Filter by status
          .get();
      // Map the documents to JsonMap
      return snapshot.docs.map((doc) => doc.data()! as JsonMap).toList();
    } catch (e) {
      // Handle any errors that may occur
      log('Error reading documents: $e');
      return []; // Return an empty list on error
    }
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Reads documents from Firestore filtered by the provided [field]
  ///  and [value].
  ///
  /// Fetches documents from Firestore filtered by the provided [field]
  /// and [value].
  /// Returns a list of [JsonMap] containing the documents.
  ///
  /// Throws an error if an exception occurs.
// /******  01f8386f-2033-4a5c-b53a-6666cb2d0d95  *******/
  Future<List<JsonMap>> readDocumentsWhere({
    required String collectionPath,
    required String field,
    required String value,
  }) async {
    final documents = <Map<String, dynamic>>[];
    try {
      final querySnapshot = await _firestore
          .collection(collectionPath)
          .where(
            field,
            isEqualTo: value,
          ).orderBy('createdAt', descending: true)
          .get();
      final data_ = querySnapshot.docs.map((e) => e.data()).toList();
      documents.addAll(data_);
      // final data = <String, dynamic>{'data': documents};
      // if (state.data != null) {
      // data.addAll(state.data!);
      // }
    } catch (e) {
      log('Error getting documents: $e');
    }
    return documents;
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Retrieves documents from Firestore for a specific user.
  ///
  /// Fetches documents from the specified [collectionPath] where the [field]
  /// matches the provided [value]. This function is typically used to get
  /// documents associated with a particular user based on a user identifier.
  /// Returns a list of maps containing the document data.
  ///
  /// Logs an error message if an exception occurs during the query process.

// /******  6347ae6e-01bb-4bc9-9726-2b01ea7bc6b1  *******/
  Future<List<Map<String, dynamic>>> getDocumentsByUserId({
    required String collectionPath,
    required String field,
    required String value,
  }) async {
    final documents = <Map<String, dynamic>>[];
    try {
      final querySnapshot = await _firestore
          .collection(collectionPath)
          .where(field, isEqualTo: value)
          .get();
      for (final document in querySnapshot.docs) {
        documents.add(document.data());
      }
      final data = <String, dynamic>{'data': documents};
      // if (state.data != null) {
      // data.addAll(state.data!);
      // }
    } catch (e) {
      log('Error getting documents: $e');
    }
    return documents;
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Reads a document from Firestore based on the provided [collectionPath]
  /// and [id].
  ///
  /// Returns a [JsonMap] containing the document data if the document exists,
  /// otherwise returns `null`.
  ///
  /// Throws an error if an exception occurs.
// /******  be59476c-b620-43ab-9441-1841b24aecfc  *******/
  Future<JsonMap?> readDocument({
    required String collectionPath,
    required String id,
  }) async {
    final ref = _firestore.collection(collectionPath).doc(id);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return snapshot.data()!;
    }
    return null;
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Updates a document in Firestore.
  ///
  /// Logs an error message if an exception occurs during the update process.
// /******  3af5aa0a-1d3a-40f4-8eb7-b07f4b23f113  *******/
  Future<void> updateDocument({
    required String collectionPath,
    required String id,
    required JsonMap data,
  }) async {
    try {
      final ref = _firestore.collection(collectionPath).doc(id);
      await ref.update(data);
    } on Exception catch (e) {
      log('Error in updateDocument: $e');
    }
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Replaces a document in Firestore with the provided [data].
  ///
  /// If a document with the given [id] exists in the specified
  /// [collectionPath],
  /// it will be overwritten with the new [data]. If no document exists, a new
  /// document will be created.
  ///
  /// Logs an error message if an exception occurs during the
  /// replacement process.

// /******  948e378f-c658-4a77-aaa7-898a6a361644  *******/
  Future<void> replaceDocument({
    required String collectionPath,
    required String id,
    required JsonMap data,
  }) async {
    final ref = _firestore.collection(collectionPath).doc(id);
    await ref.set(data);
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Returns the number of documents in the specified [collectionName].
  ///
  /// Returns `0` if an error occurs during the counting process.
  ///
  /// Logs an error message if an exception occurs during the counting process.
// /******  771806bb-79c9-43b1-b191-f43d48c6dce2  *******/
  Future<int> countDocuments(String collectionName) async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).get();
      return querySnapshot.docs.length;
    } catch (e) {
      log('Error counting documents: $e');
      return 0;
    }
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Returns a map with the count of documents in the specified
  /// [collectionName] with the following statuses:
  ///
  /// - 'Pending': The number of documents with status 'Pending'.
  /// - 'InProgress': The number of documents with status 'In Progress'.
  /// - 'Complete': The number of documents with status 'Complete'.
  ///
  /// Returns a map with all counts set to `0` if an error occurs during the
  /// counting process. Logs an error message if an exception occurs during the
  /// counting process.
// /******  8ed16a92-a663-42b1-86f9-f693fbef739c  *******/
  Future<Map<String, int>> countDocumentsByStatus(String collectionName) async {
    try {
      // Count documents with status 'Pending'
      final QuerySnapshot pendingSnapshot = await _firestore
          .collection(collectionName)
          .where('status', isEqualTo: 'Pending')
          .get();
      final pendingCount = pendingSnapshot.docs.length;
      // Count documents with status 'In Progress'
      final QuerySnapshot inProgressSnapshot = await _firestore
          .collection(collectionName)
          .where('status', isEqualTo: 'In Progress')
          .get();
      final inProgressCount = inProgressSnapshot.docs.length;
      // Count documents with status 'Complete'
      final QuerySnapshot completeSnapshot = await _firestore
          .collection(collectionName)
          .where('status', isEqualTo: 'Complete')
          .get();
      final completeCount = completeSnapshot.docs.length;
      // Return a map with the counts
      return {
        'Pending': pendingCount,
        'InProgress': inProgressCount,
        'Complete': completeCount,
      };
    } catch (e) {
      log('Error counting documents by status: $e');
      return {
        'Pending': 0,
        'InProgress': 0,
        'Complete': 0,
      };
    }
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Uploads the given [imageFile] to the Firebase Cloud Storage and
  /// returns the
  /// download URL.
  ///
  /// If the upload is successful, the download URL is saved in the Firestore
  /// document with the given [id].
  ///
  /// Returns null if an error occurs during the upload process.
  ///
// /******  4bd7b020-dd84-401a-a246-00438d8e7716  *******/
  Future<String?> uploadImage(File imageFile, JsonMap id) async {
    try {
      // Get the file extension
      final fileName = basename(imageFile.path);
      final ref = _firebaseStorage.ref().child('images/$fileName');
      // Upload the image file
      final uploadTask = ref.putFile(imageFile);
      // Wait for upload to complete
      final snapshot = await uploadTask;
      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      await saveImageUrlToFirestore(downloadUrl, id);
      return downloadUrl;
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Saves the given [downloadUrl] to the Firestore collection 'images' with
  /// the given [id].
  ///
  /// The document will contain the following fields:
  ///
  /// - 'id': The id of the user who uploaded the image.
  /// - 'uuid': The uuid of the user who uploaded the image.
  /// - 'userName': The username of the user who uploaded the image.
  /// - 'url': The download URL of the uploaded image.
  /// - 'uploaded_at': The timestamp when the image was uploaded.
  ///
  /// Logs an error message if an exception occurs during the saving process.
// /******  ca93832b-ac3b-4682-a5c2-2603d0feace9  *******/
  Future<void> saveImageUrlToFirestore(String downloadUrl, JsonMap id) async {
    try {
      await _firestore.collection('images').add({
        'id': id['id'],
        'uuid': id['uuid'],
        'userName': id['email'],
        'url': downloadUrl,
        'uploaded_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Error saving image URL to Firestore: $e');
    }
  }

/*************  ✨ Codeium Command ⭐  *************/
  /// Fetches all image URLs from the 'images' collection in Firestore.
  ///
  /// Returns an empty list if an error occurs while fetching the image URLs.
  ///
  /// This method returns a list of Strings, where each string is the download
  /// URL of an image.
// /******  d88187e2-0890-4895-a20c-871a5c062a5d  *******/
  Future<List<String>> fetchImageUrls() async {
    try {
      // Query the Firestore collection for image documents
      final QuerySnapshot snapshot =
          await _firestore.collection('images').get();

      // Extract the URLs from the documents
      final imageUrls = snapshot.docs.map((doc) {
        return doc['url'] as String; // Assuming each document has a 'url' field
      }).toList();
      return imageUrls;
    } catch (e) {
      log('Error fetching image URLs: $e');
      return [];
    }
  }

  /// Query images by id or uuid from Firestore
  Future<List<Map<String, dynamic>>> queryImages({
    String? id,
    String? uuid,
  }) async {
    try {
      // Check if either id or uuid is provided
      if (id == null && uuid == null) {
        log('Either id or uuid must be provided');
        return [];
      }

      // Create a query based on the provided id or uuid
      Query<Map<String, dynamic>> query = _firestore.collection('images');

      if (id != null) {
        query = query.where('id', isEqualTo: id);
      } else if (uuid != null) {
        query = query.where('uuid', isEqualTo: uuid);
      }

      // Execute the query
      final querySnapshot = await query.get();

      // Extract the image documents
      final images = querySnapshot.docs.map((doc) => doc.data()).toList();

      log('Query returned ${images.length} images');
      return images;
    } catch (e) {
      log('Error querying images from Firestore: $e');
      return [];
    }
  }
}

/// {@template sign_up_with_email_and_password_failure}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return SignUpWithEmailAndPasswordFailure(removeHyphen(code));
    }
  }

  /// The associated error message.
  final String message;
}
/*************  ✨ Codeium Command ⭐  *************/
/// Removes all hyphens from the given input string.
///
/// Takes a [String] [input] and returns a new [String] where
/// all occurrences of the hyphen character ('-') have been removed.

// /******  56860098-59f2-4214-a849-1efd475f6e3f  *******/
String removeHyphen(String input) {
  return input.replaceAll('-', ' ');
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return LogInWithEmailAndPasswordFailure(removeHyphen(code));
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with google process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithCredential.html
/// {@endtemplate}
class LogInWithGoogleFailure implements Exception {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const LogInWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const LogInWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const LogInWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const LogInWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const LogInWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const LogInWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return LogInWithGoogleFailure(removeHyphen(code));
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}
