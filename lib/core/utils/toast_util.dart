import 'dart:async';

import 'package:chickfit/locator.dart';
import 'package:chickfit/navigation_service.dart';
import 'package:flutter/material.dart';

class MessageUtil {
  MessageUtil._();

  static void hideSnackBar() {
    final context =
        locator.get<NavigationService>().navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  static Timer? _debounceTimer;

  static void showErrorSnackBarDebounced(
    String message, {
    Duration debounceDuration = const Duration(seconds: 2),
    SnackBarAction? action,
    bool infinite = false,
    Duration? duration,
  }) {
    // Jika ada timer yang masih aktif, jangan tampilkan toast baru
    if (_debounceTimer?.isActive ?? false) return;

    showErrorSnackBar(message,
        action: action,
        infinite: infinite,
        duration: duration, onDismissed: () {
      _debounceTimer?.cancel();
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, () {
      // Setelah debounceDuration selesai, bisa tampil lagi
    });
  }

  static void showInfoToast(
    String message, {
    SnackBarAction? action,
    bool infinite = false,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(
            locator.get<NavigationService>().navigatorKey.currentContext!)
        .showSnackBar(SnackBar(
            content: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            duration: infinite
                ? const Duration(hours: 1)
                : duration ?? const Duration(seconds: 4),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            action: action ??
                (infinite
                    ? SnackBarAction(
                        label: "Oke",
                        textColor: Colors.white,
                        onPressed: () {
                          ScaffoldMessenger.of(locator
                                  .get<NavigationService>()
                                  .navigatorKey
                                  .currentContext!)
                              .hideCurrentSnackBar();
                        })
                    : null)));
  }

  static void showErrorSnackBar(
    String message, {
    SnackBarAction? action,
    bool infinite = false,
    Duration? duration,
    Function? onDismissed,
    bool? useRootNav,
  }) {
    ScaffoldMessenger.of(
            locator.get<NavigationService>().navigatorKey.currentContext!)
        .showSnackBar(SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: const Color(0xffC72C41),
          duration: infinite
              ? const Duration(hours: 1)
              : duration ?? const Duration(seconds: 4),
          padding: const EdgeInsets.fromLTRB(6, 2, 2, 2),
          action: action ??
              SnackBarAction(
                  label: "OK",
                  textColor: Colors.blueGrey.shade200,
                  onPressed: () {
                    ScaffoldMessenger.of(locator
                            .get<NavigationService>()
                            .navigatorKey
                            .currentContext!)
                        .hideCurrentSnackBar();
                  }),
        ))
        .closed
        .then((_) {
      onDismissed?.call();
    });
  }

  static showInfoDialog(String message, {VoidCallback? onOk}) {
    // set up the button
    Widget okButton = TextButton(
      onPressed: onOk ??
          () {
            Navigator.of(locator
                    .get<NavigationService>()
                    .navigatorKey
                    .currentContext!)
                .pop(true);
          },
      child: const Text("OK"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Info"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: locator.get<NavigationService>().navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
