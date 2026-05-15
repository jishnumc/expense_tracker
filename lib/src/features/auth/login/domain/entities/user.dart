import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String nickname;
  final String token;
  final String phone;

  const User({
    required this.nickname,
    required this.token,
    required this.phone,
  });

  @override
  List<Object?> get props => [nickname, token, phone];
}
