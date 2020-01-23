import 'package:campus_mobile_experimental/core/models/events_model.dart';
import 'package:campus_mobile_experimental/core/services/networking.dart';

class EventsService {
  final String endpoint =
      'https://2jjml3hf27.execute-api.us-west-2.amazonaws.com/prod/events/student';
  bool _isLoading = false;
  DateTime _lastUpdated;
  String _error;
  List<EventModel> _data;

  final NetworkHelper _networkHelper = NetworkHelper();

  EventsService() {
    fetchData();
  }

  Future<bool> fetchData() async {
    _error = null;
    _isLoading = true;
    try {
      /// fetch data
      String _response = await _networkHelper.fetchData(endpoint);

      /// parse data
      final data = eventsModelFromJson(_response);
      _isLoading = false;
      _data = data;
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      return false;
    }
  }

  String get error => _error;
  List<EventModel> get eventsModels => _data;
  bool get isLoading => _isLoading;
  DateTime get lastUpdated => _lastUpdated;
}
