class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
  });

  // A method to convert UserModel to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'address': address,
    };
  }

  // A factory method to create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      password: map['password'],
      address: map['address'],
    );
  }
}
