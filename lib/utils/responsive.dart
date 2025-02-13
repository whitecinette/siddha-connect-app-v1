import 'package:flutter/widgets.dart';

class Responsive {
  final double width;
  final double height;

  Responsive({required this.width, required this.height});

  /// Factory method to get screen size
  factory Responsive.of(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Responsive(width: size.width, height: size.height);
  }

  /// ✅ Instance methods
  bool get isMobileDevice => width < 600;
  bool get isTabletDevice => width >= 600 && width < 1024;
  bool get isDesktopDevice => width >= 1024;

  /// ✅ Static methods (Renamed to avoid conflict)
  static bool isMobile(BuildContext context) => Responsive.of(context).isMobileDevice;
  static bool isTablet(BuildContext context) => Responsive.of(context).isTabletDevice;
  static bool isDesktop(BuildContext context) => Responsive.of(context).isDesktopDevice;
}