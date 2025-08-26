import 'package:flutter/cupertino.dart';

class Responsive{
   static bool isMobile(BuildContext context)=> MediaQuery.of(context).size.width<600;

   static bool isTablet(BuildContext context)=> MediaQuery.of(context).size.width>=600 && MediaQuery.of(context).size.width<1200;

   static bool isDesktop(BuildContext context)=> MediaQuery.of(context).size.width >= 1200;

    static double screenWidth(BuildContext context)=> MediaQuery.of(context).size.width;

    static double screenHeight(BuildContext context)=> MediaQuery.of(context).size.height;

    static double textSize(BuildContext context, double mobile, double tablet,double desktop){
      if(isMobile(context)) return mobile;
      if(isTablet(context)) return tablet;
      return desktop;
    }

    static EdgeInsets pagePadding(BuildContext context){
      if(isMobile(context)) return const EdgeInsets.all(12);
      if(isTablet(context)) return const EdgeInsets.symmetric(horizontal: 32,vertical: 20);
      return const EdgeInsets.symmetric(horizontal: 64,vertical: 32);
    }

}