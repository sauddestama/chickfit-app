import 'package:alice/alice.dart';
import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/resources.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/utils/size_util.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/data/source/local/local_storage.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/modules/home/article/bloc/article_detail_cubit.dart';
import 'package:chickfit/modules/setting/base_url_setting.dart';
import 'package:chickfit/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'core/route/page_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await LocalDataSource.init();
  await setupLocator();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (SizeUtil.getScreenWidth == 0.0) {
      SizeUtil.init(context);
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (BuildContext context) => locator<AppCubit>(),
        ),
        BlocProvider<ArticleDetailCubit>(
          create: (BuildContext context) => locator<ArticleDetailCubit>(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: locator.get<NavigationService>().navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('in', ''), // English, no country code
          Locale('id', ''), // English, no country code
        ],
        title: 'Chick Fit',
        theme: myTheme,
        initialRoute: "/",
        onGenerateRoute: generateRoute,
        builder: (context, child) {
          if (child == null) return const SizedBox();
          return Stack(
            children: [
              child,
              Visibility(
                visible: true,
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: ThemePadding.pl2,
                          width: 32.ds,
                          height: 32.ds,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AssetColors.successMain,
                              width: 1.0,
                            ),
                          ),
                          child: FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: Icon(
                              Symbols.history_edu,
                              color: AssetColors.successMain,
                            ),
                            onPressed: () {
                              locator<Alice>().showInspector();
                            },
                          ),
                        ),
                        Gap.width(8),
                        Container(
                          margin: ThemePadding.pl2,
                          width: 32.ds,
                          height: 32.ds,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AssetColors.successMain,
                              width: 1.0,
                            ),
                          ),
                          child: FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: Icon(
                              Symbols.globe,
                              color: AssetColors.successMain,
                            ),
                            onPressed: () {
                              Navigator.of(locator
                                      .get<NavigationService>()
                                      .navigatorKey
                                      .currentContext!)
                                  .push(MaterialPageRoute(builder: (_) {
                                return SettingsUrlPage();
                              }));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
