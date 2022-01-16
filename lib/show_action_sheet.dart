import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:action_sheets/action_item.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'indicator_upper_bottom_sheet.dart';
import 'action_sheets_body.dart';
import 'action_sheets_item.dart';

Future<void> showActionsSheetString(
  BuildContext context,
  List<ActionItem> actions, {
  Widget? header,
  Widget? iosTitle,
}) async {
  late String? result;
  if (Platform.isIOS) {
    result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: Theme.of(context).brightness,
        ),
        child: CupertinoActionSheet(
            title: iosTitle,
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop('Cancelar');
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyText1?.fontFamily,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            actions: actions.map((e) {
              return CupertinoActionSheetAction(
                isDefaultAction: e.isDefaultAction,
                isDestructiveAction: e.isDestructiveAction,
                child: Text(
                  e.text,
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyText1?.fontFamily,
                    color: e.isDestructiveAction
                        ? Theme.of(context).errorColor
                        : Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(e.text);
                },
              );
            }).toList()),
      ),
    );
  } else {
    result = await showModalBottomSheet<String?>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        )),
        elevation: 20,
        barrierColor: Colors.black.withOpacity(
          Theme.of(context).brightness == Brightness.dark ? 0.66 : 0.33,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IndicatorUpperBottomSheet(
                padding:
                    EdgeInsets.only(top: 8, bottom: header != null ? 12 : 0),
                color: Theme.of(context).dividerColor,
              ),
              header ?? Container(),
              const SizedBox(
                height: 4,
              ),
              ModalActionSheetBody(
                children: actions
                    .map((element) => ModalActionSheetItem(
                          text: element.text,
                          iconData: element.iconData,
                        ))
                    .toList(),
              ),
            ],
          );
        });
  }
  if (actions.any((element) => element.text == result)) {
    final _selectedItem =
        actions.firstWhere((element) => element.text == result);
    _selectedItem.onTap();
  }
}
