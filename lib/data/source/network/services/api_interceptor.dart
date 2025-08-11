import 'package:chickfit/data/repositories/auth_repository.dart';
import 'package:chickfit/locator.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await locator.get<AuthRepository>().getUserToken();
    options.headers["Accept"] = "application/json";
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }

  // @override
  // void onError(DioError err, ErrorInterceptorHandler handler) {
  //     log("errors code ${err.response!.statusCode}");
  //
  //   if (err.response != null && err.response!.statusCode == 401) {
  //     if (locator<NavigationService>().navigatorKey.currentContext != null) {
  //       Navigator.of(locator<NavigationService>().navigatorKey.currentContext!)
  //           .pushNamedAndRemoveUntil(MyRoute.loginPage, (route) => false);
  //       ToastUtil.showErrorToast("Sesi anda telah berakhir, silahkan login");
  //     }
  //   }
  //    handler.next(err);
  //
  // }
}
