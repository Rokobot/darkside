abstract class BaseApiService {
  final String baseUrl = "https://itunes.apple.com/search?term=";

  Future<dynamic> getApi(String url);

  Future<dynamic> postApi(dynamic data, String url);
}
