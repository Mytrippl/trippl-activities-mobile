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

String? attractionPriceLevelText(
  dynamic priceLevel,
  String languageCode,
) {
  final tr = languageCode == "tr";

  if (priceLevel == null) {
    return tr ? "Fiyat bilgisi yok" : "Price unavailable";
  }

  switch (priceLevel.toString().trim().toUpperCase()) {
    case "PRICE_LEVEL_FREE":
      return tr ? "Ücretsiz" : "Free";

    case "PRICE_LEVEL_INEXPENSIVE":
      return tr ? "Uygun fiyatlı" : "Budget-friendly";

    case "PRICE_LEVEL_MODERATE":
      return tr ? "Orta fiyatlı" : "Moderately priced";

    case "PRICE_LEVEL_EXPENSIVE":
      return tr ? "Pahalı" : "Expensive";

    case "PRICE_LEVEL_VERY_EXPENSIVE":
      return tr ? "Lüks fiyatlı" : "Luxury pricing";

    case "PRICE_LEVEL_UNSPECIFIED":
    default:
      return tr ? "Fiyat bilgisi yok" : "Price unavailable";
  }
}
