class FormValidator {

  static String? validateEmail(String? value) {

    if(value==null || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)){
      return "Email tidak valid";
    }
    return null;
  }

  static String? validatePassword(String? value) {

    if(value==null || value.trim().isEmpty){
      return "Password tidak boleh kosong";
    }


    return null;
  }

  static String? requiredStringValidator(String? value , {String? message}){
    if(value==null || value.trim().isEmpty){

      return message ?? 'Wajib diisi';
    }
    return null;
  }
  static String? requiredValidator<T>(T? value , {String? message}){
    if(value==null){

      return message ?? 'Wajib diisi';
    }
    return null;
  }
}

