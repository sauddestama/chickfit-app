import 'package:chickfit/modules/consultation/consultation_chat_page.dart';
import 'package:chickfit/modules/diagnose_result/diagnose_result_page.dart';
import 'package:chickfit/modules/home/doctors/doctor_detail_page.dart';
import 'package:chickfit/modules/home/home_page_wrapper.dart';
import 'package:chickfit/modules/home/chat/resep_detail_page.dart';
import 'package:chickfit/modules/home/article/article_detail_page.dart';
import 'package:chickfit/modules/login/login_page.dart';
import 'package:chickfit/modules/register/register_screen.dart';
import 'package:chickfit/modules/splash/splash_page.dart';
import 'package:flutter/material.dart';

class MyRouteName {
  MyRouteName._();

  static const String splashPage = "/";
  static const String loginPage = "/login";
  static const String registerPage = "/register";
  static const String homePage = "/home";
  static const String diagnoseResultPage = "/diagnose-result-screen";
  static const String consultationChat = "/consultation-chat";
  static const String doctorDetail = "/doctor-detail";
  static const String resepDetail = "/resep-detail";
  static const String articleDetail = "/article-detail";
}

class MyPageRoute extends PageRouteBuilder {
  final Widget page;
  final RouteSettings settings;

  MyPageRoute(this.page, this.settings)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          settings: settings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

Route<dynamic> generateRoute(RouteSettings settings) {
  Map<String, dynamic>? arguments;
  try {
    if (settings.arguments != null && settings.arguments! is Map) {
      arguments = settings.arguments as Map<String, dynamic>?;
    }
  } catch (e) {}
  switch (settings.name) {
    case MyRouteName.splashPage:
      return MyPageRoute(SplashPage(), settings);
    case MyRouteName.loginPage:
      return LoginPage.route(settings);
    case MyRouteName.registerPage:
      return RegisterScreen.route(settings);
    case MyRouteName.homePage:
      return HomeScreenWrapper.route(settings);
    case MyRouteName.diagnoseResultPage:
      return DiagnosisResultPage.route(settings);
    case MyRouteName.doctorDetail:
      return DoctorDetailPage.route(settings);
    case MyRouteName.consultationChat:
      return ConsultationChatPage.route(settings);
    case MyRouteName.resepDetail:
      return ResepDetailPage.route(settings);
    case MyRouteName.articleDetail:
      return ArticleDetailPage.route(settings);

    default:
      return MyPageRoute(SplashPage(), settings);
  }
}

class MyPageRouteRightToLeft extends PageRouteBuilder {
  final Widget page;
  final RouteSettings settings;

  MyPageRouteRightToLeft(this.page, this.settings)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          settings: settings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
