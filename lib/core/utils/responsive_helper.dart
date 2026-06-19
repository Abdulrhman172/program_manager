import 'package:flutter/material.dart';

/// مساعد الاستجابة للشاشات - يوفر ثوابت ودوال لتكييف الواجهة مع جميع أحجام الشاشات
class Responsive {
  // نقاط التوقف (Breakpoints)
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  /// عدد أعمدة الشبكة بناءً على حجم الشاشة
  static int gridColumns(BuildContext context, {int mobile = 2, int tablet = 2, int desktop = 4}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// الحشو (padding) الرئيسي للصفحات
  static EdgeInsets pagePadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(12);
    if (isTablet(context)) return const EdgeInsets.all(20);
    return const EdgeInsets.all(24);
  }

  /// حجم الخط المتكيف
  static double fontSize(BuildContext context, {
    double mobile = 13,
    double tablet = 14,
    double desktop = 15,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// العرض المتاح للمحتوى
  static double contentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isDesktop(context)) return width - 260; // عرض الـ Drawer
    return width;
  }

  /// نسبة عرض/ارتفاع البطاقة (aspect ratio)
  static double cardAspectRatio(BuildContext context) {
    if (isMobile(context)) return 1.6;
    if (isTablet(context)) return 1.8;
    return 2.0;
  }
}

/// Widget مساعد يُعيد بناء المحتوى بناءً على حجم الشاشة
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: builder);
  }
}

/// GridView متكيف مع حجم الشاشة تلقائياً
class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double childAspectRatio;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const AdaptiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
    this.spacing = 12,
    this.childAspectRatio = 1.6,
    this.shrinkWrap = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        if (constraints.maxWidth < Responsive.mobileBreakpoint) {
          columns = mobileColumns;
        } else if (constraints.maxWidth < Responsive.tabletBreakpoint) {
          columns = tabletColumns;
        } else {
          columns = desktopColumns;
        }

        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
          shrinkWrap: shrinkWrap,
          physics: physics ?? const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}
