import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final IconData icon;
  final String name;
  final String value;

  Square(
      {Key? key, required this.icon, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
                AutoSizeText(
                  value,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                AutoSizeText(name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.5)))
              ],
            ),
          ),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}
