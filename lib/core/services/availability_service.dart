import 'package:campus_mobile_experimental/core/models/availability_model.dart';
import 'package:campus_mobile_experimental/core/services/networking.dart';

class AvailabilityService {
  AvailabilityService() {}
  bool _isLoading = false;
  DateTime _lastUpdated;
  String _error;
  List<AvailabilityModel> _data;

  /// add state related things for view model here
  /// add any type of data manipulation here so it can be accessed via provider

  List<AvailabilityModel> get data => _data;

  final NetworkHelper _networkHelper = NetworkHelper();
  final Map<String, String> headers = {
    "accept": "application/json",
  };
  final String endpoint = "https://ucsd-mobile-dev.s3-us-west-1.amazonaws.com/mock-apis/occuspace/availability-mock-api.json";

  Future<bool> fetchData() async {
    _error = null;
    _isLoading = true;
    try {
      /// fetch data
      String _response = await _networkHelper.authorizedFetch(endpoint, headers);

      /// parse data
      final data = availabilityModelFromJson(_response);
      _isLoading = false;

      _data = data;
      return true;
    } catch (e) {
      /// if the authorized fetch failed we know we have to refresh the
      /// token for this service
      if (e.response != null && e.response.statusCode == 401) {
        if (await getNewToken()) {
          return await fetchData();
        }
      }
      _error = e.toString();
      _isLoading = false;
      return false;
    }
  }

  Future<bool> getNewToken() async {
    final String tokenEndpoint = "https://api-qa.ucsd.edu:8243/token";
    final Map<String, String> tokenHeaders = {
      "content-type": 'application/x-www-form-urlencoded',
      "Authorization": "Basic WUNaMXlLTW9wMjNxcGtvUFQ1aDYzdHB5bm9rYTpQNnFCbWNIRFc5azNJME56S3hHSm5QTTQzV0lh"
    };
    try {
      var response = await _networkHelper.authorizedPost(
          tokenEndpoint, tokenHeaders, "grant_type=client_credentials");
      headers["Authorization"] = "Bearer " + response["access_token"];
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  bool get isLoading => _isLoading;

  String get error => _error;

  DateTime get lastUpdated => _lastUpdated;
}
