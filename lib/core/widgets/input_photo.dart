import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chickfit/core/resources/asset_colors.dart';
import 'package:chickfit/core/utils/size_config.dart';
import 'package:chickfit/core/widgets/circle_icon_widget.dart';
import 'package:chickfit/modules/image_viewer/image_viewer_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class InputPhoto extends StatelessWidget {
  final Function(String? path)? onChange;

  /// default image url
  final String? defaultImage;
  final String? pathFile;
  final double? width;

  final double? height;

  final bool showEditBtn;

  const InputPhoto(
      {Key? key,
      this.onChange,
      this.defaultImage,
      this.pathFile,
      this.width,
      this.height,
      this.showEditBtn = false})
      : super(key: key);

  final int _imagePickerQuality = 50;

  @override
  Widget build(BuildContext context) {
    double imageContainerWidth = MediaQuery.of(context).size.width - 12;
    double imageContainerHeight = MediaQuery.of(context).size.width - 12;

    return SizedBox(
      width: width == null ? (imageContainerWidth + 20) : width! + 20,
      height: height ?? imageContainerHeight,
      child: Stack(
        children: [
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: width ?? imageContainerWidth,
                height: height ?? imageContainerHeight,
                child: _buildImage(context),
              ),
            ),
          ),
          Visibility(
            visible: showEditBtn,
            child: Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: AssetColors.colorPrimary,
                  elevation: 3,
                  onPressed: () {
                    showModalSelectInputPhoto(context);
                  },
                  child: const Icon(Icons.camera_alt_outlined),
                )),
          ),
        ],
      ),
    );
  }

  _buildImage(context) {
    if (defaultImage != null && pathFile == null) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ImageViewerScreen(
                    tag: '$pathFile',
                    imageUrl: defaultImage!,
                    network: true,
                  )));
        },
        child: CachedNetworkImage(
          imageUrl: defaultImage!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Shimmer.fromColors(
            child: Container(color: Colors.white),
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
          ),
          errorWidget: (context, url, error) => Icon(
              Icons.broken_image_outlined,
              size: width != null
                  ? width! - 10
                  : SizeConfig.screenWidth / 4 - 10),
        ),
      );
    }
    if (pathFile == null) {
      return DottedBorder(
        color: AssetColors.colorPrimaryDark,
        dashPattern: [4, 2, 4, 2],
        radius: Radius.circular(14),
        strokeWidth: 2,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.white),
                  backgroundColor: AssetColors.colorPrimary,
                ),
                onPressed: () {
                  showModalSelectInputPhoto(context);
                },
                child: const Text(
                  'Pilih Gambar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Text(
                '*Masukkan foto lidah dengan jelas dan tanpa efek kamera',
                style: const TextStyle(),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }
    if (pathFile != null) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ImageViewerScreen(
                    tag: '$pathFile',
                    imageWidget: Image(
                        fit: BoxFit.fitWidth,
                        image: FileImage(File(pathFile!))),
                  )));
        },
        child: Image(fit: BoxFit.fitWidth, image: FileImage(File(pathFile!))),
      );
    }
  }

  void showModalSelectInputPhoto(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleIconWidget(
                      title: 'Gallery',
                      icon: FontAwesomeIcons.images,
                      onTap: () async {
                        _pickImage(context, ImageSource.gallery);
                      }),
                  const SizedBox(width: 10),
                  CircleIconWidget(
                      title: 'Photo',
                      icon: Icons.camera_alt,
                      onTap: () async {
                        _pickImage(context, ImageSource.camera);
                      }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _pickImage(BuildContext context, var source) async {
    Navigator.pop(context);
    var file = await ImagePicker()
        .pickImage(source: source, imageQuality: _imagePickerQuality);
    if (file != null && onChange != null) {
      onChange!(file.path);
    }
  }
}
