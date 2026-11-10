import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared route transitions (Material motion). Every route uses one of
/// these helpers. When the phone has "remove animations" on, the page
/// appears instantly.
const _duration = Duration(milliseconds: 300);

bool _reduced(BuildContext context) =>
    MediaQuery.maybeOf(context)?.disableAnimations ?? false;

/// Fade-through: used for tabs and the PIN unlock → Today change.
CustomTransitionPage<T> fadeThroughPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: _duration,
    reverseTransitionDuration: _duration,
    transitionsBuilder: (context, animation, secondary, child) {
      if (_reduced(context)) return child;
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondary,
        child: child,
      );
    },
  );
}

/// Shared axis, horizontal: onboarding steps 1–5, forward and back.
CustomTransitionPage<T> sharedAxisPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: _duration,
    reverseTransitionDuration: _duration,
    transitionsBuilder: (context, animation, secondary, child) {
      if (_reduced(context)) return child;
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondary,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      );
    },
  );
}

/// Fade only: used for the PIN unlock → Today change.
CustomTransitionPage<T> simpleFadePage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: _duration,
    reverseTransitionDuration: _duration,
    transitionsBuilder: (context, animation, secondary, child) {
      if (_reduced(context)) return child;
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

/// Modal bottom sheet slides up: used by the daily log. Implemented as a
/// helper so the call site stays consistent.
Future<T?> showSlideUpSheet<T>(BuildContext context, WidgetBuilder builder) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Colors.transparent,
    builder: builder,
  );
}
