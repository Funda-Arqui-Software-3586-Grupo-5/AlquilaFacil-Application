class Constant {
   static const String BASE_URL = "http://10.0.2.2:8000/";
   static const String IAM_PATH = "iam/";
   static const String LOCAL_PATH = "local/";
   static const String NOTIFICATION_PATH ="notification/";
   static const String PROFILE_PATH = "profile/";
   static const String SUBSCRIPTION_PATH = "subscription/";
   static const String BOOKING_PATH = "booking/";

   static String getEndpoint(String resourcePath, String route, String? path){
      return BASE_URL + resourcePath  + route + path!;
   }
}