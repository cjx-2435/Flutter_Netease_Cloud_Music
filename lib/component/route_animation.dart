import 'package:flutter/material.dart';

class CustomRoute extends PageRouteBuilder {
  final Widget widget;
  CustomRoute(this.widget):super(
    transitionDuration: Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) {
      return widget;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 渐隐渐现
      return FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          )
        ),
        child: child,
      );
      // 缩放
      // return ScaleTransition(
      //   scale: Tween(begin: 0.0, end: 1.0).animate(
      //     CurvedAnimation(
      //       parent: animation,
      //       curve: Curves.fastOutSlowIn
      //     )
      //   ),
      //   child: child,
      // );
      // 旋转+缩放
      // return RotationTransition(
      //   turns: Tween(begin: 0.0, end: 1.0).animate(
      //     CurvedAnimation(
      //       parent: animation,
      //       curve: Curves.fastOutSlowIn
      //     )
      //   ),
      //   child: ScaleTransition(
      //     scale: Tween(begin: 0.0, end: 1.0).animate(
      //       CurvedAnimation(
      //         parent: animation,
      //         curve: Curves.fastOutSlowIn
      //       )
      //     ),
      //     child: child,
      //   ),
      // );
      // 左右滑动
      // return SlideTransition(
      //   position: Tween(
      //     begin: Offset(-1.0, 0.0), 
      //     end: Offset(0.0, 0.0)
      //   ).animate(CurvedAnimation(
      //     parent: animation,
      //     curve: Curves.fastOutSlowIn)
      //   ),
      //   child: child,
      // );
    },
  );
}