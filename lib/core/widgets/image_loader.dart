import 'package:cached_network_image/cached_network_image.dart';
import 'package:chickfit/modules/image_viewer/image_viewer_screen.dart';
import 'package:flutter/material.dart';

import 'shimmer_box.dart';

class ImageLoader extends StatelessWidget {
  const ImageLoader({
    Key? key,
    required this.url,
    this.placeholder,
    this.imageBuilder,
    this.errorWidget,
    this.fit = BoxFit.cover,
    this.width = 60,
    this.height = 50,
    this.radius = 10,
    this.iconSize = 35,
    this.withShadow = false,
  }) : super(key: key);

  final String url;
  final PlaceholderWidgetBuilder? placeholder;
  final ImageWidgetBuilder? imageBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final BoxFit fit;
  final double width;
  final double height;
  final double radius;
  final double iconSize;
  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'imageLoader$url',
      child: CachedNetworkImage(
          imageUrl: url,
          placeholder: placeholder ??
              (context, url) => ShimmerBox(
                    height: height,
                    width: width,
                    radius: radius,
                  ),
          imageBuilder: imageBuilder ??
              (context, provider) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ImageViewerScreen(
                                tag: url,
                                imageUrl: url,
                                network: true,
                              )));
                    },
                    child: Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: Colors.white,
                        boxShadow: [
                          if (withShadow)
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(0, 0),
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          radius,
                        ),
                        child: Image(
                          image: provider,
                          fit: fit,
                        ),
                      ),
                    ),
                  ),
          errorWidget: errorWidget ??
              (context, url, error) => Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: Colors.grey.shade300,
                  ),
                  child: Icon(Icons.broken_image_outlined, size: iconSize))),
    );
  }
}
