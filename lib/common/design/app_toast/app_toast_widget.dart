import 'package:bit_transit/common/color.dart';
import 'package:bit_transit/common/typography.dart';
import 'package:bit_transit/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


enum AppToastType {
  error,
  warning,
  info,
  success,
}

enum AppToastLayout {
  filled,
  outlined,
  standard,
}

extension AppToastMainColor on AppToastType {
  Color get mainColor {
    switch (this) {
      case AppToastType.error:
        return colorAlertRed;
      case AppToastType.warning:
        return colorAlertYellow;
      case AppToastType.info:
        return colorAlertBlue;
      case AppToastType.success:
        return colorAlertGreen;
    }
  }

  Color get iconColor {
    return colorGrayWhite;
  }
}

class AppToastWidget extends StatelessWidget {
  const AppToastWidget({
    super.key,
    required this.title,
    this.description,
    this.type = AppToastType.error,
    this.layout = AppToastLayout.filled,
    this.margin,
    this.padding,
    this.maxLines,
  });
  final String title;
  final String? description;
  final AppToastType type;
  final AppToastLayout layout;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: margin ??
            EdgeInsets.symmetric(
              horizontal: 20.px,
              vertical: 20.px,
            ).copyWith(top: MediaQuery.of(context).padding.top),
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 16.px,
              vertical: 12.px,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.px),
          ),
          border: layout != AppToastLayout.outlined
              ? null
              : Border.all(width: 1, color: type.mainColor),
          color: bgColor,
        ),
        child: Row(
          crossAxisAlignment: description == null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12.px),
              child: icon,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  if (description != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.px),
                      child: Text(
                        "$description",
                        maxLines: maxLines ?? 40,
                        overflow: TextOverflow.ellipsis,
                        style: tStyle.body3.Regular.tColor(contentColor),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Text _buildTitle() {
    return description == null
        ? Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tStyle.body2.Regular.tColor(contentColor),
          )
        : Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tStyle.body2.Medium.tColor(contentColor),
          );
  }

  Color get contentColor {
    switch (layout) {
      case AppToastLayout.filled:
        return colorGrayWhite;

      case AppToastLayout.outlined:
      case AppToastLayout.standard:
        return type.mainColor;
    }
  }

  Color get bgColor {
    switch (layout) {
      case AppToastLayout.outlined:
        return Colors.transparent;
      case AppToastLayout.filled:
        return type.mainColor;
      case AppToastLayout.standard:
        return type.mainColor.withOpacity(0.2);
    }
  }

  Widget get icon {
    switch (type) {
      case AppToastType.error:
        return [AppToastLayout.outlined, AppToastLayout.standard]
                .contains(layout)
            ? Assets.icons.exclamationCircleOutlined.svg()
            : Assets.icons.exclamationCircle.svg();
      case AppToastType.info:
        return [AppToastLayout.outlined, AppToastLayout.standard]
                .contains(layout)
            ? Assets.icons.infoCircleOutlined.svg()
            : Assets.icons.infoCircle.svg();

      case AppToastType.warning:
        return [AppToastLayout.outlined, AppToastLayout.standard]
                .contains(layout)
            ? Assets.icons.triangleExclamationOutlined.svg()
            : Assets.icons.triangleExclamation.svg();
      case AppToastType.success:
        return [AppToastLayout.outlined, AppToastLayout.standard]
                .contains(layout)
            ? Assets.icons.checkCircleOutlined.svg()
            : Assets.icons.checkCircle.svg();
    }
  }
}
