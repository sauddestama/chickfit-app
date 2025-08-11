import 'package:chickfit/data/source/local/local_storage.dart';
import 'package:chickfit/data/source/network/services/api_service.dart';

class BaseRepository {
  final ApiService _apiClient;

  ApiService get apiClient => _apiClient;

  final LocalDataSource _localDataSource;

  LocalDataSource get localDataSource => _localDataSource;

  BaseRepository({
    required ApiService apiClient,
    required LocalDataSource localDataSource,
  })  : _apiClient = apiClient,
        _localDataSource = localDataSource;
}
