import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

AttractionPriceRange getAttractionPriceLevel(dynamic value) {
  if (value == null) {
    return AttractionPriceRange.unknown;
  }

  final price = value.toString().trim().toUpperCase();

  switch (price) {
    case "PRICE_LEVEL_FREE":
      return AttractionPriceRange.free;

    case "PRICE_LEVEL_INEXPENSIVE":
      return AttractionPriceRange.cheap;

    case "PRICE_LEVEL_MODERATE":
      return AttractionPriceRange.moderate;

    case "PRICE_LEVEL_EXPENSIVE":
      return AttractionPriceRange.expensive;

    case "PRICE_LEVEL_VERY_EXPENSIVE":
      return AttractionPriceRange.luxury;

    default:
      return AttractionPriceRange.unknown;
  }
}
