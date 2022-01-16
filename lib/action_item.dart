import 'dart:async';

import 'package:flutter/material.dart';

class ActionItem {
  ActionItem(
    this.text,
    this.iconData,
    this.onTap, {
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });

  final IconData? iconData;
  final String text;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final FutureOr<void> Function() onTap;
}
