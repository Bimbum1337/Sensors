import 'package:flutter/material.dart';
import 'package:untitled5/utils/colors_manager.dart';

class DataWorkouts extends StatelessWidget {
  final String icon;
  final String title;
  final int count;
  final String text;
  final Widget? btn;
  const DataWorkouts({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.text,
    this.btn,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 90,
      width: screenWidth * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorsManager.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.secondaryBackground.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Image(
                image: AssetImage(icon),
                width: 25,
                height: 25,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: ColorsManager.primaryText,
                ),
                maxLines: 1,
              ),
              const Spacer(),
              const SizedBox(
                width: 4,
              ),
              if (btn != null) btn!,
            ],
          ),
          Row(
            children: [
              if (count > -1)
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.primaryText,
                  ),
                )
              else
                const SizedBox(
                  width: 35,
                ),
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorsManager.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
