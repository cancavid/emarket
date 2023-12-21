import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum MsOutlineButtonStyle {
  black,
  white,
}

class MsOutlineButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  final double? fontSize;
  final double height;
  final MsOutlineButtonStyle style;
  const MsOutlineButton({
    super.key,
    required this.onTap,
    required this.title,
    this.fontSize,
    this.height = 54.0,
    this.style = MsOutlineButtonStyle.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: (style == MsOutlineButtonStyle.black) ? Colors.black : Colors.white),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              height: 1.2,
              fontSize: (fontSize != null) ? fontSize : 13.0,
              color: (style == MsOutlineButtonStyle.black) ? Colors.black : Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
