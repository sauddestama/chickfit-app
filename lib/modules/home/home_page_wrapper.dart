import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/data/repositories/consultation_repository.dart';
import 'package:chickfit/data/repositories/data_repository.dart';
import 'package:chickfit/data/repositories/diagnose_repository.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/modules/home/article/article_screen.dart';
import 'package:chickfit/modules/home/article/bloc/article_cubit.dart';
import 'package:chickfit/modules/home/bloc/dashboard_cubit.dart';
import 'package:chickfit/modules/home/bloc/home_cubit.dart';
import 'package:chickfit/modules/home/chat/bloc/chat_cubit.dart';
import 'package:chickfit/modules/home/chat/bloc/consultation_cubit.dart';
import 'package:chickfit/modules/home/chat/bloc/prescriptions_cubit.dart';
import 'package:chickfit/modules/home/chat/chat_screen.dart';
import 'package:chickfit/modules/home/dashboard/dashboard_screen.dart';
import 'package:chickfit/modules/home/diagnose/bloc/diagnose_form_cubit.dart';
import 'package:chickfit/modules/home/diagnose/bloc/diagnose_histories_cubit.dart';
import 'package:chickfit/modules/home/diagnose/diagnose_screen.dart';
import 'package:chickfit/modules/home/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenWrapper extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final List<BottomNavItem> navItems = [
    BottomNavItem(
      icon: 'assets/icons/home.svg',
      label: 'Home',
      activeColor: AssetColors.primaryMain,
    ),
    BottomNavItem(
      icon: 'assets/icons/explore.svg',
      label: 'Explore',
      activeColor: AssetColors.primaryMain,
    ),
    BottomNavItem(
      icon: 'assets/icons/diagnose.svg',
      label: 'Diagnosa',
      activeColor: AssetColors.primaryMain,
    ),
    BottomNavItem(
      icon: 'assets/icons/chat.svg',
      label: 'Chat',
      activeColor: AssetColors.primaryMain,
    ),
    BottomNavItem(
      icon: 'assets/icons/profile.svg',
      label: 'Profile',
      activeColor: AssetColors.primaryMain,
    ),
  ];

  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    return MyPageRouteRightToLeft(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeCubit()
                ..initData(initialPageIndex: args?['initialPageIndex']),
            ),
            BlocProvider(
              create: (context) => DashboardCubit(
                dataRepository: locator<DataRepository>(),
              )..fetchDashboardData(),
            ),
            BlocProvider(
              create: (context) => ArticleCubit(
                dataRepository: locator<DataRepository>(),
              )..fetchArticles(),
            ),
            BlocProvider(
              create: (context) => DiagnoseHistoriesCubit(
                dataRepository: locator<DiagnoseRepository>(),
                consultationRepository: locator(),
              ),
            ),
            BlocProvider(
              create: (context) => DiagnoseFormCubit(),
            ),
            BlocProvider(
              create: (context) => ConsultationsCubit(
                  dataRepository: locator<ConsultationRepository>())
                ..fetchConsultations(),
            ),
            BlocProvider(
              create: (context) => PrescriptionsCubit(
                  dataRepository: locator<ConsultationRepository>()),
            ),
            BlocProvider(
              create: (context) => ChatCubit(),
            ),
          ],
          child: HomeScreenWrapper._(),
        ),
        settings);
  }

  HomeScreenWrapper._({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: _Body(),
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: BottomNavigationBar(
                  currentIndex: state.homePageActiveIndex,
                  onTap: (index) {
                    context.read<HomeCubit>().setActiveHomePageIndex(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  selectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AssetColors.primaryMain,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AssetColors.textSecondary,
                  ),
                  selectedItemColor: AssetColors.primaryMain,
                  unselectedItemColor: AssetColors.textSecondary,
                  items: navItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    BottomNavItem item = entry.value;
                    bool isSelected = state.homePageActiveIndex == index;

                    return BottomNavigationBarItem(
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Gap.height(12),
                          SvgPicture.asset(
                            item.icon,
                            height: 25,
                            colorFilter: ColorFilter.mode(
                              isSelected
                                  ? item.activeColor
                                  : AssetColors.textSecondary,
                              BlendMode.srcIn,
                            ),
                          ),
                          Gap.height(4),
                        ],
                      ),
                      label: item.label,
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // return list[state.homePageActiveIndex];
        return IndexedStack(
          index: state.homePageActiveIndex,
          children: [
            const DashboardScreen(),
            const ArticleScreen(),
            const DiagnoseScreen(),
            ChatScreen(),
            const ProfileScreen()
          ],
        );
      },
    );
  }
}

class BottomNavItem {
  final String icon;
  final String label;
  final Color activeColor;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.activeColor,
  });
}
