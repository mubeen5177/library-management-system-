class Validation {
  static bool isValidEmail(String? value) {
    RegExp urlExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+", caseSensitive: false);

    return value != null && value.trim().isNotEmpty && (urlExp.hasMatch(value));
  }

  static String? validateString(String? value) {
    return value != null && value.trim().isNotEmpty ? null : 'Incorrect Value';
  }


  static String? isDateValid(String? date) {
    // Define a regular expression pattern for "DD/MM/YYYY" format
    final pattern = r'^\d{2}/\d{2}/\d{4}$';

    // Create a regular expression object
    final regex = RegExp(pattern);

     if(regex.hasMatch(date!)){
       return null;
     }
     else{
       return 'Please enter correct date!';
     }

  }


  static String? validateEmail(String? email) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (email == null) {
      return null;
    } else {
      if (email.length == 0) {
        return "Email is Required";
      } else if (!regExp.hasMatch(email)) {
        return "Invalid Email";
      } else {
        return null;
      }
    }
  }

  static String? isValidPakistanPhoneNumber(String? phoneNumber) {
    // Define the regular expression pattern for a Pakistan phone number
    final RegExp phoneNumberRegExp = RegExp(r'^(\+92|0)[1-9][0-9]{8}$');

    // Use the RegExp's 'hasMatch' method to check if the phone number matches the pattern
    if (phoneNumberRegExp.hasMatch(phoneNumber!)) {
      return null;
    } else {
      return null;
    }
  }

  static String? isValidStreetAddress(String? address) {
    // Regular expression to match a basic street address
    // This allows for letters, numbers, spaces, hyphens, and commas.
    final pattern = r'^[a-zA-Z0-9\s\-,.#]+$';
    final regex = RegExp(pattern);
    if (regex.hasMatch(address!)) {
      return null;
    } else {
      return "Enter Address!";
    }
  }

  static String? validatePinCode(String? v) {
    if (v!.length < 4) {
      return "Please enter pin code";
    } else {
      return null;
    }
  }

  static String? validatePassword(String? password) {
    if (password == null || password == "") {
      return "Password is required!";
    } else if (password.length < 8) {
      return "Password must have 8 characters";
    }
    return null;
  }

  static String? validateConfirmationPassword(String password, String? confirmationPassword) {
    if (confirmationPassword == null || confirmationPassword == "") {
      return "Confirmation Password is Required";
    } else if (confirmationPassword.length < 8) {
      return "Password must have 8 characters";
    } else if (confirmationPassword != password) {
      return "Passwords do not match";
    }
    return null;
  }
}
