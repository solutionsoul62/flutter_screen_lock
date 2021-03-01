import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/configurations/input_button_config.dart';
import 'package:flutter_screen_lock/configurations/screen_lock_config.dart';
import 'package:flutter_screen_lock/configurations/secrets_config.dart';
import 'package:flutter_screen_lock/heading_title.dart';
import 'package:flutter_screen_lock/screen_lock.dart';

/// Animated ScreenLock
///
/// - `correctString`: Input correct string (Required).
///   If [confirmation] is `true`, it will be ignored, so set it to any string or empty.
/// - `screenLockConfig`: Configurations of [ScreenLock]
/// - `canCancel`: `true` is show cancel button
/// - `confirmation`: Make sure the first and second inputs are the same.
/// - `digits`: Set the maximum number of characters to enter when [confirmation] is `true`.
/// - `didUnlocked`: Called if the value matches the correctString.
/// - `didError`: Called if the value does not match the correctString.
/// - `didMaxRetries`: Events that have reached the maximum number of attempts
/// - `didOpened`: For example, when you want to perform biometric authentication
/// - `didConfirmed`: Called when the first and second inputs match during confirmation
/// - `customizedButtonTap`: Tapped for left side lower button
/// - `customizedButtonChild`: Child for bottom left side button
/// - `footer`: Add a Widget to the footer
Future<T> screenLock<T>({
  @required BuildContext context,
  @required String correctString,
  ScreenLockConfig screenLockConfig = const ScreenLockConfig(),
  SecretsConfig secretsConfig = const SecretsConfig(),
  InputButtonConfig inputButtonConfig = const InputButtonConfig(),
  bool canCancel = true,
  bool confirmation = false,
  int digits = 4,
  void Function() didUnlocked,
  void Function(int retries) didError,
  void Function(int retries) didMaxRetries,
  void Function() didOpened,
  void Function(String matchedText) didConfirmed,
  Future<void> Function() customizedButtonTap,
  Widget customizedButtonChild,
  Widget footer,
  Widget cancelButton,
  Widget deleteButton,
  Widget title = const HeadingTitle(text: 'Please enter passcode.'),
  Widget confirmTitle =
      const HeadingTitle(text: 'Please enter confirm passcode.'),
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black.withOpacity(0.8),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secodaryAnimation,
      ) {
        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (didOpened != null) {
              didOpened();
            }
          }
        });
        return ScreenLock(
          correctString: correctString,
          screenLockConfig: screenLockConfig,
          secretsConfig: secretsConfig,
          inputButtonConfig: inputButtonConfig,
          canCancel: canCancel,
          confirmation: confirmation,
          digits: digits,
          didUnlocked: didUnlocked,
          didError: didError,
          didMaxRetries: didMaxRetries,
          didConfirmed: didConfirmed,
          custmizedButtonTap: customizedButtonTap,
          customizedButtonChild: customizedButtonChild,
          footer: footer,
          deleteButton: deleteButton,
          cancelButton: cancelButton,
          title: title,
          confirmTitle: confirmTitle,
        );
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 2.4),
            end: Offset.zero,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, 2.4),
            ).animate(secondaryAnimation),
            child: child,
          ),
        );
      },
    ),
  );
}