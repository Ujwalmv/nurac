class ApiConstants {
  static const String baseUrl = 'https://tras.nurac.com/api';
  // static const String userBaseUrl = "https://tras.nurac.com/users";

  static String login(String username, String password) =>
      '$baseUrl/api/login/both/$username/$password';
  // static String userLogin(String username, String password) =>
  //     '$baseUrl/login/both/$username/$password';

  static String members(int associationId) => '$baseUrl/members/$associationId';

  static String birthdays(int associationId) =>
      '$baseUrl/birthday/$associationId';

  static String residentDetails(String resId) => '$baseUrl/addresses/$resId';
}
