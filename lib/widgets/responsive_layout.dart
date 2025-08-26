import 'package:flutter/cupertino.dart';
import 'package:goldapi/utils/responsive.dart';

class ResponsiveLayout extends StatelessWidget{
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key?key,
    required this.mobile,
    this.tablet,
    this.desktop
}): super(key: key);

  @override
  Widget build(BuildContext context) {
    if(Responsive.isDesktop(context) && desktop!=null){
      return desktop!;
    }
    else if(Responsive.isTablet(context) && tablet!=null){
      return tablet!;
    }
    else{
      return mobile;
    }
  }

}