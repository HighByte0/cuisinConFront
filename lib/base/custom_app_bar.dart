import 'package:flutter/material.dart';
import 'package:food_delivery_flutter/utils/colors.dart';
import 'package:food_delivery_flutter/widgets/big_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButtonExist;
  final Function? onBackPress;

  const CustomAppBar({
    super.key, 
    required this.title, 
    this.backButtonExist = true, 
    this.onBackPress
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BigText(
        text: title,
        color: Color.fromARGB(255, 85, 4, 207),
      ),
      elevation: 0,
      backgroundColor: AppColors.mainColor,
      centerTitle: true,
      leading: backButtonExist
          ? IconButton(
              onPressed: () => onBackPress != null
                  ? onBackPress!()
                  : Navigator.pushReplacementNamed(context, "/initial"),
              icon: Icon(Icons.arrow_back_ios),
            )
          : SizedBox.shrink(),
    );
  }
   @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(500, 50);
}
