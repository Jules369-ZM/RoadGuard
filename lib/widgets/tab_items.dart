import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TabItem extends StatelessWidget {

  const TabItem({
    required this.title, required this.count, super.key,
  });
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              
            ),
          ),
        ],
      ),
    );
  }
}
