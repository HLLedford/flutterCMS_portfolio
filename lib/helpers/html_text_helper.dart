import 'package:flutter/material.dart';

class HtmlTextHelper {
  static List<TextSpan> returnCleanHtml(String body) {
    if (body.contains("<b>")) {
      return _cleanHtmlWithBoldTags(body);
    } else {
      return [TextSpan(text: _replaceBreaksAndTabs(body, padded: false))];
    }
  }

  static List<TextSpan> _cleanHtmlWithBoldTags(String body) {
    List<TextSpan> retVal = <TextSpan>[];

    List<String> bodyText = body
        .replaceAll("<br>", " <br> ")
        .replaceAll("&nbsp;", " &nbsp; ")
        .split(" ");

    String currentTextSpanText = "";

    for (var element in bodyText) {
      if (element.contains("<b>") && element.contains("</b>")) {
        if (currentTextSpanText != "") {
          String textSpanText =
              _replaceBreaksAndTabs(currentTextSpanText + " ", padded: true);

          retVal.add(TextSpan(text: textSpanText));
        }

        String textSpanText = _replaceBreaksAndTabs(
            element.replaceAll("<b>", "").replaceAll("</b>", "") + " ",
            padded: true);

        retVal.add(TextSpan(
            text: textSpanText,
            style: const TextStyle(fontWeight: FontWeight.bold)));

        currentTextSpanText = "";
      } else if (element.contains("<b>")) {
        if (currentTextSpanText != "") {
          String textSpanText =
              _replaceBreaksAndTabs(currentTextSpanText + " ", padded: true);

          retVal.add(TextSpan(text: textSpanText));
        }

        currentTextSpanText = element.replaceAll("<b>", "");
      } else if (element.contains("</b>")) {
        String textSpanText = _replaceBreaksAndTabs(
            currentTextSpanText + " " + element.replaceAll("</b>", "") + " ",
            padded: true);

        retVal.add(TextSpan(
            text: textSpanText,
            style: const TextStyle(fontWeight: FontWeight.bold)));

        currentTextSpanText = "";
      } else {
        currentTextSpanText = currentTextSpanText + " " + element;
      }
    }

    if (currentTextSpanText != "") {
      String textSpanText =
          _replaceBreaksAndTabs(currentTextSpanText + " ", padded: true);

      retVal.add(TextSpan(text: textSpanText));
    }

    return retVal;
  }

  static String _replaceBreaksAndTabs(String text, {bool padded = true}) {
    return padded
        ? text
            .replaceAll(" <br> ", "\n\n")
            .replaceAll(" &nbsp; ", String.fromCharCode(0x00A0))
        : text
            .replaceAll("<br>", "\n\n")
            .replaceAll("&nbsp;", String.fromCharCode(0x00A0));
  }
}
