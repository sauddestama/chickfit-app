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

class InputPhoto2 extends FormField<String> {
  final Function(String? path)? onChange;

  /// default image url
  final String? defaultImage;
  final String? pathFile;
  final double? width;
  final double? height;

  final bool showEditBtn;
  final bool required;
  final String? descText;

  InputPhoto2(
      {Key? key,
      this.onChange,
      this.defaultImage,
      this.pathFile,
      this.width,
      this.height,
      this.descText,
      this.required = false,
      this.showEditBtn = false})
      : super(
            key: key,
            validator: (value) {
              if (required && (value == null || value.isEmpty)) {
                return "Foto harus diisi";
              }
              return null;
            },
            builder: (FormFieldState<String> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width ??
                        ((MediaQuery.of(state.context).size.width * 8 / 10)),
                    height: height ?? MediaQuery.of(state.context).size.width,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          width: width ??
                              (MediaQuery.of(state.context).size.width *
                                      8 /
                                      10) -
                                  20,
                          height:
                              height ?? MediaQuery.of(state.context).size.width,
                          child: Builder(builder: (context) {
                            if (defaultImage != null && pathFile == null) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => ImageViewerScreen(
                                            tag: '$pathFile',
                                            imageUrl: defaultImage,
                                            network: true,
                                          )));
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: defaultImage,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        child: Container(color: Colors.white),
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.broken_image_outlined,
                                              size: width != null
                                                  ? width - 10
                                                  : SizeConfig.screenWidth / 4 -
                                                      10),
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (pathFile == null) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                clipBehavior: Clip.antiAlias,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: AssetColors.colorPrimaryDark,
                                  dashPattern: const [4, 2, 4, 2],
                                  radius: const Radius.circular(20),
                                  strokeWidth: 2,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: const TextStyle(
                                                color: Colors.white),
                                            backgroundColor:
                                                AssetColors.colorPrimary,
                                          ),
                                          onPressed: () {
                                            showModalSelectInputPhoto(context,
                                                onChange: (value) {
                                              state.didChange(value);
                                              onChange?.call(value);
                                            });
                                          },
                                          child: const Text(
                                            'Pilih Gambar',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Text(
                                          descText ?? '',
                                          style: const TextStyle(),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ImageViewerScreen(
                                          tag: pathFile,
                                          imageWidget: Image(
                                              fit: BoxFit.fitWidth,
                                              image: FileImage(File(pathFile))),
                                        )));
                              },
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                elevation: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                      fit: BoxFit.fitWidth,
                                      image: FileImage(File(pathFile))),
                                ),
                              ),
                            );
                            return Container();
                          }),
                        ),
                        Visibility(
                          visible: showEditBtn,
                          child: Positioned(
                              top: 0,
                              right: 0,
                              child: FloatingActionButton(
                                mini: true,
                                backgroundColor: Colors.redAccent,
                                elevation: 3,
                                onPressed: () {
                                  showModalSelectInputPhoto(state.context,
                                      onChange: (value) {
                                    state.didChange(value);
                                    onChange?.call(value);
                                  });
                                },
                                child: const Icon(Icons.edit),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: state.hasError,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(state.context).size.width * 1 / 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 8,
                      ),
                      child: Text(
                        state.errorText ?? '',
                        style: const TextStyle(fontSize: 13, color: Colors.red),
                      ),
                    ),
                  )
                ],
              );
            });
}

void showModalSelectInputPhoto(BuildContext context,
    {Function(String? path)? onChange}) {
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
                      _pickImage(context, ImageSource.gallery, onChange);
                    }),
                const SizedBox(width: 10),
                CircleIconWidget(
                    title: 'Photo',
                    icon: Icons.camera_alt,
                    onTap: () async {
                      _pickImage(context, ImageSource.camera, onChange);
                    }),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void _pickImage(
    BuildContext context, var source, Function(String? path)? onChange) async {
  const int _imagePickerQuality = 50;
  Navigator.pop(context);
  var file = await ImagePicker()
      .pickImage(source: source, imageQuality: _imagePickerQuality);
  if (file != null && onChange != null) {
    onChange(file.path);
  }
}
