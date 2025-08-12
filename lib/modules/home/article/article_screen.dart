import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/route/page_route.dart';
import 'package:chickfit/core/utils/size_util.dart';
import 'package:chickfit/core/widgets/back_icon_widget.dart';
import 'package:chickfit/core/widgets/button/button_primary.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/ink_pressable_base.dart';
import 'package:chickfit/core/widgets/search_input_widget.dart';
import 'package:chickfit/core/widgets/shimmer_box.dart';
import 'package:chickfit/core/widgets/widgets.dart';
import 'package:chickfit/data/source/network/responses/article_item_response.dart';
import 'package:chickfit/modules/home/article/bloc/article_cubit.dart';
import 'package:chickfit/modules/home/article/widgets/chip_selection_widget.dart';
import 'package:chickfit/modules/home/bloc/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ArticleCubit>().fetchArticles();
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              Gap.height(16),
              ChipSelectionWidget(),
              SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<ArticleCubit, ArticleState>(
                  builder: (context, state) {
                    if (state.articleDataStatus == DataStatus.loading ||
                        state.articleDataStatus == DataStatus.initial) {
                      // Loading state using shimmer placeholders for article cards
                      return SingleChildScrollView(
                        padding: ThemePadding.ph16,
                        child: Column(
                          children: List.generate(
                              4, (index) => const _ArticleCardShimmer()),
                        ),
                      );
                    }
                    if (state.articleDataStatus != DataStatus.success) {
                      // Error state
                      return ErrorListWidget(
                        pullToRefresh: false,
                      );
                    }
                    return SingleChildScrollView(
                      padding: ThemePadding.ph16,
                      child: Column(
                        children:
                            List.generate(state.articles?.length ?? 0, (idx) {
                          final article = state.articles![idx];
                          return _ArticleCard(article: article);
                        }),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
    return InkPressableBase(
      onTap: () {
        Navigator.of(context).pushNamed(
          MyRouteName.articleDetail,
          arguments: {'articleId': article.id},
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                article.thumbnailUrl ?? "",
                height: SizeUtil.getScreenWidth * 1 / 3,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: SizeUtil.getScreenWidth * 1 / 3,
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
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
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
              height: SizeUtil.getScreenWidth * 1 / 3,
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

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          left: 16.ds, right: 16.ds, top: SizeUtil.getStatusBarHeight),
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
          SizedBox(height: 8.ds),
          Row(
            children: [
              InkPressableBase(
                child: BackIconWidget(
                  onTap: () {
                    context.read<HomeCubit>().setActiveHomePageIndex(0);
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Explore Artikel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.ds,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.ds),
          SearchInput(
            hintText: "Car artikel kesehatan ayam..",
            onChanged: (value) {},
          ),
          SizedBox(height: 8.ds),
        ],
      ),
    );
  }
}
