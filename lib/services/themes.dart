import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




TextStyle get subHeadingStyle {
    return GoogleFonts.lato(
        textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black87
        )
    );
  }

  TextStyle get headingStyle {
    return GoogleFonts.lato(
        textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87
        )
    );
  }

  TextStyle get trailingStyle {
    return GoogleFonts.lato(
        textStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black87
        )
    );
  }
