import 'package:flutter/services.dart';
import 'package:zeerah/core/common/app_exports.dart';

void copydata(BuildContext context, String data) {
  Clipboard.setData(ClipboardData(text: data));

   ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Code copied to clipboard"),
      duration: Duration(seconds: 2),
    ),
  );
}
