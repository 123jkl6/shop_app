import "package:flutter/material.dart";
import 'package:flutter/src/material/page_transitions_theme.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    //not animate first screen
    if (settings.isInitialRoute){
      return child;
    }

    return FadeTransition(opacity: animation,child:child);
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
     //not animate first screen
    if (route.settings.isInitialRoute){
      return child;
    }

    return FadeTransition(opacity: animation,child:child);
  }
}