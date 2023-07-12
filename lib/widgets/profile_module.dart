class Profile {
  final String name;
  final String email;
  String? bio;

  Profile({required this.name, required this.email, this.bio});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'],
      email: map['email'],
      bio: map['bio'],
    );
  }
}
