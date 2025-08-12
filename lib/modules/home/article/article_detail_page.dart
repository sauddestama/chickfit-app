import 'package:chickfit/core/enum/enum_data_status.dart';
import 'package:chickfit/core/ext/number_extension.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/resources/theme/theme_padding.dart';
import 'package:chickfit/core/widgets/back_icon_widget.dart';
import 'package:chickfit/core/widgets/error_list_widget.dart';
import 'package:chickfit/core/widgets/gap.dart';
import 'package:chickfit/core/widgets/loading_ring.dart';
import 'package:chickfit/core/widgets/widgets.dart';
import 'package:chickfit/locator.dart';
import 'package:chickfit/modules/home/article/bloc/article_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleDetailPage extends StatefulWidget {
  final int articleId;

  const ArticleDetailPage({
    super.key,
    required this.articleId,
  });

  static Route<dynamic> route(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>;
    final articleId = arguments['articleId'] as int;

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => ArticleDetailCubit(dataRepository: locator()),
        child: ArticleDetailPage(
          articleId: articleId,
        ),
      ),
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

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ArticleDetailCubit>().fetchArticleDetail(widget.articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AssetColors.primaryMain,
        automaticallyImplyLeading: false,
        elevation: 2,
        centerTitle: false,
        title: Row(
          children: [
            BackIconWidget(
              onTap: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Detail Artikel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AssetColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ArticleDetailCubit, ArticleDetailState>(
          builder: (context, state) {
            if (state.articleDetailDataStatus.loading ||
                state.articleDetailDataStatus.initial) {
              return const Center(
                child: const SpinKitRing(
                  color: AssetColors.colorPrimaryShades,
                ),
              );
            }

            if (!state.articleDetailDataStatus.success) {
              return ErrorListWidget(
                pullToRefresh: false,
                onRetry: () {
                  context
                      .read<ArticleDetailCubit>()
                      .fetchArticleDetail(widget.articleId);
                },
              );
            }

            final article = state.article;
            if (article == null) {
              return const Center(
                child: Text('Artikel tidak ditemukan'),
              );
            }

            return _buildArticleContent(article);
          },
        ),
      ),
    );
  }

  Widget _buildArticleContent(article) {
    return SingleChildScrollView(
      padding: ThemePadding.pa16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article Image
          if (article.thumbnailUrl != null) ...[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  article.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            ),
            Gap.height(24),
          ],

          // Article Title
          Text(
            article.title ?? 'Judul Artikel',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AssetColors.textPrimary,
              height: 1.3,
            ),
          ),
          Gap.height(16),

          // Article Meta Information
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: AssetColors.textSecondary,
              ),
              Gap.width(8),
              Text(
                article.authorName ?? 'Unknown Author',
                style: TextStyle(
                  fontSize: 14,
                  color: AssetColors.textSecondary,
                ),
              ),
              Gap.width(16),
              Icon(
                Icons.access_time,
                size: 16,
                color: AssetColors.textSecondary,
              ),
              Gap.width(8),
              Text(
                _formatDate(article.createdAt),
                style: TextStyle(
                  fontSize: 14,
                  color: AssetColors.textSecondary,
                ),
              ),
            ],
          ),
          Gap.height(24),

          // Article Content
          Text(
            article.content ?? 'Konten artikel tidak tersedia',
            style: TextStyle(
              fontSize: 14.ds,
              color: AssetColors.textBody,
              height: 1.6,
            ),
          ),
          Gap.height(32),
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
