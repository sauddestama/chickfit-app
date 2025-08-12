import 'package:alice/alice.dart';
import 'package:chickfit/app_config.dart';
import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/data/repositories/consultation_repository.dart';
import 'package:chickfit/data/repositories/diagnose_repository.dart';
import 'package:chickfit/data/source/local/local_storage.dart';
import 'package:chickfit/modules/home/article/bloc/article_detail_cubit.dart';
import 'package:chickfit/navigation_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'data/repositories/repositories.dart';
import 'data/source/network/services/api_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton(NavigationService());
  locator.registerSingleton(Alice(
    navigatorKey: locator<NavigationService>().navigatorKey,
    showNotification: false,
  ));
  final localDataSource = LocalDataSource();
  locator.registerSingleton<LocalDataSource>(localDataSource);
  final baseUrl = await localDataSource.getBaseUrl() ?? AppConfig().baseUrl;
  final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: Duration(minutes: 3),
      connectTimeout: Duration(minutes: 3),
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      }));

  locator.registerSingleton<Dio>(dio);
  locator.registerSingleton(ApiService(
    locator<Dio>(),
  ));

  locator.registerSingleton(AuthRepository(
      apiClient: locator<ApiService>(),
      localDataSource: locator<LocalDataSource>()));
  locator.registerSingleton(UserRepository(
      apiClient: locator<ApiService>(),
      localDataSource: locator<LocalDataSource>()));
  locator.registerSingleton(DataRepository(
      apiClient: locator<ApiService>(),
      localDataSource: locator<LocalDataSource>()));
  locator.registerSingleton(DiagnoseRepository(
      apiClient: locator<ApiService>(),
      localDataSource: locator<LocalDataSource>()));
  locator.registerSingleton(ConsultationRepository(
      apiClient: locator<ApiService>(),
      localDataSource: locator<LocalDataSource>()));
  locator.registerSingleton(ArticleDetailCubit(
      dataRepository: locator<DataRepository>()));
  locator.registerSingleton(AppCubit());
}
