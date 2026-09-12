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

String tripplActivitesPriceLabel(
  dynamic price,
  Currency? currency,
  String locale,
) {
  if (price == null || currency == null) {
    return '';
  }

  double? parsedPrice;

  if (price is num) {
    parsedPrice = price.toDouble();
  } else if (price is String) {
    final value = price.trim();

    if (value.contains(',') && value.contains('.')) {
      // Example: 6,132.18
      parsedPrice = double.tryParse(value.replaceAll(',', ''));
    } else if (value.contains(',')) {
      // Example: 6132,18
      parsedPrice = double.tryParse(value.replaceAll(',', '.'));
    } else {
      parsedPrice = double.tryParse(value);
    }
  }

  if (parsedPrice == null || parsedPrice.isNaN || parsedPrice.isInfinite) {
    return '';
  }

  final isTurkish = locale.toLowerCase().startsWith('tr');

  // Thousands separator + up to 2 decimal places.
  // .00 is removed automatically.
  final formatter = NumberFormat(
    '#,##0.##',
    isTurkish ? 'tr_TR' : 'en_US',
  );

  final formattedPrice = formatter.format(parsedPrice);

  String symbol;

  switch (currency) {
    case Currency.USD:
      symbol = '\$';
      break;

    case Currency.CAD:
      symbol = 'C\$';
      break;

    case Currency.GBP:
      symbol = '£';
      break;

    case Currency.EUR:
      symbol = '€';
      break;

    case Currency.TR:
      symbol = '₺';
      break;

    default:
      symbol = '';
  }

  if (isTurkish) {
    return '$formattedPrice$symbol / kişi';
  }

  return 'From $symbol$formattedPrice / person';
}
