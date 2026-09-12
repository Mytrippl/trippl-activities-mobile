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

String activityOptionName(
  String productTitle,
  dynamic item,
) {
  final optionCode = item['productOptionCode'];
  final startTime = item['startTime'];

  String title = productTitle;

  // If option code exists, append it
  if (optionCode != null && optionCode.toString().isNotEmpty) {
    title = '$productTitle - $optionCode';
  }

  // Format time (handle "17:00" or "17:00:00")
  String? formattedTime;

  if (startTime != null && startTime.toString().isNotEmpty) {
    final parts = startTime.toString().split(':');
    if (parts.length >= 2) {
      formattedTime = '${parts[0]}:${parts[1]}';
    }
  }

  if (formattedTime != null) {
    return '$title – $formattedTime';
  }

  return title;
}
