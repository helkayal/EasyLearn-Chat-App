import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePic;
  final String status;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePic = '',
    this.status = 'Offline',
    this.createdAt,
  });

  // Convert Firestore Document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      status: map['status'] ?? 'Offline',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert UserModel to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'status': status,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

final List<UserModel> dummyUsers = [
  UserModel(
    uid: '1',
    name: 'Robert Fox',
    email: 'robert@example.com',
    status: 'Hey, let’s play basketball',
    profilePic: 'https://i.pravatar.cc/150?u=1',
  ),
  UserModel(
    uid: '2',
    name: 'Esther Howard',
    email: 'esther@example.com',
    status: 'Perfect, see you later',
    profilePic: 'https://i.pravatar.cc/150?u=2',
  ),
  UserModel(
    uid: '3',
    name: 'Jacob Jones',
    email: 'jacob@example.com',
    status: 'Oh you’re right lmao',
    profilePic: 'https://i.pravatar.cc/150?u=3',
  ),
  UserModel(
    uid: '4',
    name: 'Bessie Cooper',
    email: 'bessie@example.com',
    status: 'Don’t forget abt tonight babe',
    profilePic: 'https://i.pravatar.cc/150?u=4',
  ),
  UserModel(
    uid: '5',
    name: 'Albert Flores',
    email: 'albert@example.com',
    status: 'Bro wanna play basketball...',
    profilePic: 'https://i.pravatar.cc/150?u=5',
  ),
  UserModel(
    uid: '6',
    name: 'Floyd Miles',
    email: 'floyd@example.com',
    status: 'Hey, let’s play basketball',
    profilePic: 'https://i.pravatar.cc/150?u=6',
  ),
  UserModel(
    uid: '7',
    name: 'Arlene McCoy',
    email: 'arlene@example.com',
    status: 'Is the meeting still on?',
    profilePic: 'https://i.pravatar.cc/150?u=7',
  ),
  UserModel(
    uid: '8',
    name: 'Devon Lane',
    email: 'devon@example.com',
    status: 'Just sent the files over!',
    profilePic: 'https://i.pravatar.cc/150?u=8',
  ),
  UserModel(
    uid: '9',
    name: 'Courtney Henry',
    email: 'courtney@example.com',
    status: 'That was hilarious 😂',
    profilePic: 'https://i.pravatar.cc/150?u=9',
  ),
  UserModel(
    uid: '10',
    name: 'Kathryn Murphy',
    email: 'kathryn@example.com',
    status: 'See you at the office',
    profilePic: 'https://i.pravatar.cc/150?u=10',
  ),
];
