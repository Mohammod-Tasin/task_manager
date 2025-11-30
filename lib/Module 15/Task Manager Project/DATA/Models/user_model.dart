class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;
  final String photo;

  String get fullName {
    return '$firstName $lastName';
  }

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.photo
  });
  // kono named constructor
  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      id: jsonData['_id'],
      email: jsonData['email'],
      firstName: jsonData['firstName'],
      lastName: jsonData['lastName'],
      mobile: jsonData['mobile'],
      photo: jsonData['photo'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'photo' : photo
    };
  }
}

//│ 💡 Body: {"status":"success","data":
// {"_id":"691c680c880cc5d30a2ffa1b",
// "email":"tr@gmail.com",
// "firstName":"t",
// "lastName":"r",
// "mobile":"0177777777",
// "createdDate":"2025-10-02T06:21:41.011Z"},
// "token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NjM1NTU3NDEsImRhdGEiOiJ0ckBnbWFpbC5jb20iLCJpYXQiOjE3NjM0NjkzNDF9.Nu1SmK0d9CXMx5OtxGaFHhfFSQkUajd7dVWW8Wc42jc"}
