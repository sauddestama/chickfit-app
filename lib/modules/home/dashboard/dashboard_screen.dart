import 'package:chickfit/app_cubit.dart';
import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/size_util.dart';
import 'package:chickfit/core/widgets/button/button_primary.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/core/widgets/search_input_widget.dart';
import 'package:chickfit/core/widgets/shimmer_box.dart';
import 'package:chickfit/core/widgets/widgets.dart';
import 'package:chickfit/data/source/network/responses/article_item_response.dart';
import 'package:chickfit/modules/home/bloc/dashboard_cubit.dart';
import 'package:chickfit/modules/home/bloc/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (old, state) {
        return old.homePageActiveIndex != state.homePageActiveIndex &&
            old.homePageActiveIndex != 0 &&
            state.homePageActiveIndex == 0;
      },
      listener: (context, state) {
        if (state.homePageActiveIndex == 0) {
          scrollController.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        }
      },
      child: Scaffold(
        backgroundColor: AssetColors.backgroundColor,
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<DashboardCubit>().fetchDashboardData();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: kToolbarHeight),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      if (state.data == null) return const SizedBox();
                      return _Header(
                        name: state.data!.name!,
                        userInitial: state.data!.initials,
                        imageUrl: state.data!.avatarUrl,
                      );
                    },
                  ),
                  Gap.height(16),
                  // Section: Layanan Utama
                  Padding(
                    padding: ThemePadding.ph16,
                    child: Text("Layanan Utama",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: ThemePadding.ph16,
                    child: Row(
                      children: [
                        _ServiceCard(
                          icon: Symbols.stethoscope,
                          label: "Diagnosa",
                          onClick: () {
                            context.read<HomeCubit>().setActiveHomePageIndex(2);
                          },
                        ),
                        _ServiceCard(
                          icon: Symbols.chat_bubble_outline,
                          label: "Konsultasi",
                          onClick: () {
                            context.read<HomeCubit>().setActiveHomePageIndex(3);
                          },
                        ),
                        _ServiceCard(
                          icon: Symbols.article,
                          label: "Artikel",
                          onClick: () {
                            context.read<HomeCubit>().setActiveHomePageIndex(1);
                          },
                        ),
                        _ServiceCard(
                          icon: Symbols.person,
                          label: "Profile",
                          onClick: () {
                            context.read<HomeCubit>().setActiveHomePageIndex(4);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Section: Dokter Tersedia
                  Padding(
                    padding: ThemePadding.ph16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Dokter Tersedia",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Lihat Semua",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, state) {
                      if (state.dashboardDataStatus.loading ||
                          state.dashboardDataStatus.initial) {
                        return SingleChildScrollView(
                          padding: ThemePadding.pa16,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                4, (index) => const _DoctorCardShimmer()),
                          ),
                        );
                      }
                      if (!state.dashboardDataStatus.success) {
                        return ErrorListWidget(
                          pullToRefresh: false,
                        );
                      }
                      return SingleChildScrollView(
                        padding: ThemePadding.pa16,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              state.veterinarians?.length ?? 0, (idx) {
                            final veterinarian = state.veterinarians![idx];
                            return _DoctorCard(
                              name: veterinarian.name!,
                              title: veterinarian.specialization ?? "",
                              rating: veterinarian.rating?.toDouble() ?? 0,
                              imageUrl: veterinarian.avatarUrl,
                              userInitial: veterinarian.initials,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MyRouteName.doctorDetail,
                                    arguments: {'doctor': veterinarian});
                              },
                            );
                          }),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8),

                  // Section: Artikel Terbaru
                  Padding(
                    padding: ThemePadding.ph16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Artikel Terbaru",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("Lihat Semua",
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, state) {
                      if (state.dashboardDataStatus.loading ||
                          state.dashboardDataStatus.initial) {
                        // Loading state using shimmer placeholders for article cards
                        return SingleChildScrollView(
                          padding: ThemePadding.ph16,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                3, (index) => const _ArticleCardShimmer()),
                          ),
                        );
                      }
                      if (!state.dashboardDataStatus.success) {
                        // Error state
                        return ErrorListWidget(
                          pullToRefresh: false,
                        );
                      }
                      return SingleChildScrollView(
                        padding: ThemePadding.ph16,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              List.generate(state.articles?.length ?? 0, (idx) {
                            final article = state.articles![idx];
                            return _ArticleCard(article: article);
                          }),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({
    required this.name,
    required this.title,
    required this.rating,
    required this.imageUrl,
    required this.userInitial,
    required this.onTap,
  });

  final String name;
  final String title;
  final double rating;
  final String? imageUrl;
  final String userInitial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12),
      child: InkPressableBase(
        onTap: onTap,
        child: Ink(
          width: 150,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            children: [
              if (imageUrl == null)
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xff4BB88D),
                  child: Text(userInitial,
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                )
              else
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xff4BB88D),
                  backgroundImage: NetworkImage(
                    imageUrl!,
                  ),
                ),
              SizedBox(height: 8),
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(rating.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorCardShimmer extends StatelessWidget {
  const _DoctorCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(height: 4),
          _CenteredShimmerBox(height: 70, width: 70, radius: 35),
          SizedBox(height: 12),
          _CenteredShimmerBox(height: 14, width: 110, radius: 8),
          SizedBox(height: 8),
          _CenteredShimmerBox(height: 12, width: 80, radius: 8),
          SizedBox(height: 12),
          _CenteredShimmerBox(height: 12, width: 60, radius: 8),
        ],
      ),
    );
  }
}

class _CenteredShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const _CenteredShimmerBox({
    required this.height,
    required this.width,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShimmerBox(height: height, width: width, radius: radius),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.label,
    required this.onClick,
  });

  final IconData icon;
  final String label;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: ThemePadding.ph2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkPressableBase(
              onTap: onClick,
              child: AspectRatio(
                aspectRatio: 1.0, // 1:1 ratio (square)
                child: Ink(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: AssetColors.primaryMain,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 45.ds),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: AssetColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final String userInitial;
  final String? imageUrl;

  const _Header({
    required this.name,
    required this.userInitial,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.ds,
        right: 16.ds,
        top: SizeUtil.getStatusBarHeight,
      ),
      decoration: BoxDecoration(
        color: AssetColors.primaryMain,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.ds),
          bottomRight: Radius.circular(20.ds),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Halo, $name!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.ds,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Selamat datang di ChickFit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.ds,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (imageUrl == null)
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xff4BB88D),
                  child: Text(userInitial,
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                )
              else
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xff4BB88D),
                  backgroundImage: NetworkImage(
                    imageUrl!,
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.ds),
          SearchInput(
            hintText: "Car artikel atau dokter..",
            onChanged: (value) {},
          ),
          SizedBox(height: 12.ds),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final ArticleItemResponse article;

  const _ArticleCard({
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeUtil.getScreenWidth * 0.8,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              article.thumbnailUrl ?? "",
              height: SizeUtil.getScreenWidth * 0.8 * 1 / 3,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: SizeUtil.getScreenWidth * 0.8 * 1 / 3,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? "Judul Artikel",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  article.content ?? "Deskripsi artikel tidak tersedia",
                  style: TextStyle(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${article.authorName ?? 'Unknown'} • ${_formatDate(article.createdAt)}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      child: ButtonPrimary(
                        text: "Baca",
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            MyRouteName.articleDetail,
                            arguments: {'articleId': article.id},
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown date";
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return "${difference.inDays} hari yang lalu";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} jam yang lalu";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} menit yang lalu";
    } else {
      return "Baru saja";
    }
  }
}

class _ArticleCardShimmer extends StatelessWidget {
  const _ArticleCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeUtil.getScreenWidth * 0.8,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: ShimmerBox(
              height: SizeUtil.getScreenWidth * 0.8 * 1 / 3,
              width: double.infinity,
              radius: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // Title placeholder
                ShimmerBox(height: 16, width: 200, radius: 8),
                SizedBox(height: 6),
                // Content placeholder
                ShimmerBox(height: 12, width: 250, radius: 8),
                SizedBox(height: 6),
                ShimmerBox(height: 12, width: 180, radius: 8),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ShimmerBox(height: 12, width: 120, radius: 8),
                    ),
                    SizedBox(width: 8),
                    ShimmerBox(height: 36, width: 60, radius: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
