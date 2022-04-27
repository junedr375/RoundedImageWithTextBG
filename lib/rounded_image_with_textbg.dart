library rounded_image_with_textbg;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:string_to_hex/string_to_hex.dart';

class RoundedImageWithTextAndBG extends StatelessWidget {
  ///radius of the circle,
  ///Height = radius *2
  ///Width = radius *2
  final double? radius;

  ///Padding arround the loadingWidget
  final double? loaderPadding;

  ///Network Image URL
  ///Send empty if Text with Random Backround needed
  ///If image.isEmpty = true, then the image will be a circle with a random color generated according to the [uniqueId] with [text] as initials in center
  final String image;

  ///Intials of the text will be used to show in the circle
  ///With constant Random Background Color to give effect like Gmail
  final String text;

  ///If Background is provided it will be used
  ///Otherwise Random Color will be assigned
  final Color? backgroudColor;

  ///Unique radix16 String needed to generate Random and Constant Color
  ///For e.g. 'ac170002-7446-1152-8174-46096d7f0000'
  ///or Firebase UID e.g. 'cT3GNJXiWPbB3fExrFHoD42LK263' will work
  final String? uniqueId;

  ///Assest Image path for error Image
  final String? errorImage;

  ///Network Image loading Widget Default is CircularProgressIndicator
  final Widget? loadingWidget;

  ///Loading Widget Circular Progress Indicator Color
  final Color? circularProgressColor;

  ///Color For TEXT intials
  final Color? backgroundTextColor;

  ///TextStyle for TEXT intials
  final TextStyle? textStyle;

  ///Network Image BoxFit
  final BoxFit? fit;

  ///To Show selected Widget
  final bool? isSelected;

  ///Custuom Selection Widget
  final Widget? selectedWidget;

  ///Selection Widget Background Color
  final Color? selectedBackgroundColor;

  ///Callback function onTap of the Widget
  final VoidCallback? onTap;

  const RoundedImageWithTextAndBG(
      {Key? key,
      this.radius = 16,
      this.loaderPadding = 10,
      required this.image,
      required this.text,
      this.backgroudColor,
      this.uniqueId,
      this.errorImage,
      this.loadingWidget,
      this.circularProgressColor,
      this.backgroundTextColor = Colors.white,
      this.textStyle = const TextStyle(
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w500,
      ),
      this.fit = BoxFit.cover,
      this.isSelected = false,
      this.selectedBackgroundColor,
      this.selectedWidget,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Size(radius! * 2, radius! * 2);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: (isSelected ?? false)
              ? selectedWidget ??
                  Container(
                    height: size.height,
                    width: size.width,
                    color: selectedBackgroundColor ?? Colors.green[400],
                    child: Icon(
                      Icons.done,
                      size: radius,
                      color: Colors.white,
                    ),
                  )
              : Container(
                  height: size.height,
                  width: size.width,
                  alignment: Alignment.center,
                  color: backgroudColor ?? generateRandomColor(),
                  child: image.isNotEmpty
                      ? Image.network(
                          image,
                          alignment: Alignment.center,
                          height: size.height,
                          width: size.width,
                          errorBuilder: (ctx, err, _) => _InitialsWidget(
                            text: text,
                            textColor: backgroudColor ?? Colors.white,
                            textStyle: textStyle ??
                                const TextStyle(
                                  fontSize: 11,
                                  height: 16 / 11,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return loadingWidget ??
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(loaderPadding!),
                                    child: CircularProgressIndicator(
                                      color:
                                          circularProgressColor ?? Colors.blue,
                                    ),
                                  ),
                                );
                          },
                          fit: fit,
                        )
                      : _InitialsWidget(
                          text: text,
                          textColor: backgroudColor ?? Colors.white,
                          textStyle: textStyle ??
                              const TextStyle(
                                fontSize: 11,
                                height: 16 / 11,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                ),
        ),
      ),
    );
  }

  Color generateRandomColor() {
    Random random = Random();
    int lengthFactor = (text.isEmpty ? 1 : text.length) % 9;
    if (lengthFactor == 0) {
      lengthFactor = 9;
    }
    int shadeFactor = random.nextInt(lengthFactor) * 100;
    if (shadeFactor < 500) {
      shadeFactor += 500;
    }
    Color? _randomColor = Colors
        .primaries[random.nextInt(Colors.primaries.length)][shadeFactor]
        ?.withOpacity(0.9);

    Color? hexColor;
    try {
      if (uniqueId != null) {
        hexColor = getColorFromString(uniqueId ?? '');
      }
    } catch (e) {
      if (kDebugMode) {
        print('$uniqueId is not a valid radix string');
      }
    }
    return hexColor ?? _randomColor ?? Colors.black;
  }
}

class _InitialsWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color textColor;
  const _InitialsWidget(
      {Key? key,
      required this.text,
      required this.textStyle,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        getNameInitials(),
        style: textStyle.copyWith(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  String getNameInitials() {
    String initials = text.contains(' ')
        ? text.split(' ')[0][0].toUpperCase() +
            text.split(' ')[1][0].toUpperCase()
        : text.substring(0, 1).toUpperCase();
    return initials;
  }
}

Color getColorFromString(String radix16String) {
  return Color(StringToHex.toColor(radix16String));
}
