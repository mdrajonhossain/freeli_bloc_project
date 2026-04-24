abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginSubmitted(this.email, this.password);
}

class LoginSelectCompany extends LoginEvent {
  final String email;
  final String password;
  final String companyId;
  LoginSelectCompany(this.email, this.password, this.companyId);
}

class LoginVerifyOtp extends LoginEvent {
  final String email;
  final String password;
  final String? companyId;
  final String code;
  LoginVerifyOtp(this.email, this.password, this.companyId, this.code);
}
