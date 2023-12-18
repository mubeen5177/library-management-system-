import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension BuildContextExtension<T> on BuildContext {
  BoxFit checkVideoRatio(double width, double height) {
    if (width > height) {
      return BoxFit.contain;
    } else if (width < height) {
      return BoxFit.cover;
    } else {
      return BoxFit.contain;
    }
  }

  SizedBox sizedBox({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  bool get isMobile => MediaQuery.of(this).size.width <= 500.0;

  bool get isTablet => MediaQuery.of(this).size.width < 1024.0 && MediaQuery.of(this).size.width >= 650.0;

  bool get isSmallTablet => MediaQuery.of(this).size.width < 650.0 && MediaQuery.of(this).size.width > 500.0;

  bool get isDesktop => MediaQuery.of(this).size.width >= 1024.0;

  bool get isSmall => MediaQuery.of(this).size.width < 850.0 && MediaQuery.of(this).size.width >= 560.0;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  Size get size => MediaQuery.of(this).size;

  dynamic pop([Object? ob]) => Navigator.of(this).pop(ob);

  pushAndRemoveUntil(Widget widget) {
    Navigator.pushAndRemoveUntil(
        this,
        CupertinoPageRoute(
          builder: (BuildContext context) => widget,
        ),
        (Route<dynamic> route) => false);
  }

  push(Widget widget) {
    Navigator.push(
      this,
      CupertinoPageRoute(
        builder: (BuildContext context) => widget,
      ),
    );
  }
  pushReplacement(Widget widget) {
    Navigator.pushReplacement(
      this,
      CupertinoPageRoute(
        builder: (BuildContext context) => widget,
      ),
    );
  }
}
