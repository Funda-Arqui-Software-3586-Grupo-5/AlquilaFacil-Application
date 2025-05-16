abstract class AuthService {
   Future<Map<String,dynamic>> signIn(String email, String password);
   Future<String> signUp(String username, String password, String email);
}