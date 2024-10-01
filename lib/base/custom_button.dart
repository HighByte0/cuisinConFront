import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:food_delivery_flutter/utils/dimensions.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;

  CustomButton({
    Key? key,
    this.onPressed,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.height,
    this.width,
     this.fontSize,
    this.radius = 5,
    this.icon,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButton = TextButton.styleFrom(
      backgroundColor: widget.onPressed == null
          ? Theme.of(context).disabledColor
          : widget.transparent
              ? Colors.transparent
              : Theme.of(context).primaryColor,
      minimumSize: Size(widget.width ?? Dimensions.screenWidth, widget.height ?? Dimensions.height50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius),
      ),
    );

    return Center(
      child: SizedBox(
        width: widget.width ?? Dimensions.screenWidth,
        height: widget.height ?? Dimensions.height50,
        child: TextButton(
          onPressed: widget.onPressed,
          style: _flatButton,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Padding(
                  padding: EdgeInsets.only(
                    right: Dimensions.width10 / 2,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.transparent
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor,
                  ),
                ),
              Text(
                widget.buttonText,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.transparent
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
