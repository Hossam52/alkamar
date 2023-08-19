import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {Key? key,
      required this.label,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.textAlign})
      : super(key: key);

  final String label;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(label,
        textAlign: textAlign ?? TextAlign.start,
        style: Theme.of(context).textTheme.caption!.copyWith(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ));
  }
}
