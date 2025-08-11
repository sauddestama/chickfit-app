import 'package:cached_network_image/cached_network_image.dart';
import 'package:chickfit/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String? imageUrl;
  final Image? imageWidget;
  final String tag;
  final String? title;
  final bool network;
  ImageViewerScreen(
      {Key? key,
      this.imageUrl,
      this.imageWidget,
      required this.tag,
      this.title,
      this.network = false})
      : super(key: key) {
    if (network) {
      assert(network && imageUrl != null);
    } else {
      assert(!network && imageWidget != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        title: Text(title ?? 'Gambar'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: network
              ? Hero(
                  tag: tag,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    placeholder: (context, url) => const LoadingWave(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
              : imageWidget!,
        ),
      ),
    );
  }
}
