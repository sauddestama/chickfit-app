class ChangePasswordRequest {
  final String currentPass;
  final String newPass;

  const ChangePasswordRequest({
    required this.currentPass,
    required this.newPass,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': this.currentPass,
      'newPassword': this.newPass,
    };
  }
}
