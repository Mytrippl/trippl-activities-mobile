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

Color activityRatingBoxColor(
  dynamic rating,
  int type,
) {
  double? value;

  if (rating is num) {
    value = rating.toDouble();
  } else if (rating is String) {
    value = double.tryParse(
      rating.trim().replaceAll(',', '.'),
    );
  }

  final isShadow = type == 2;

  // Missing or invalid rating: orange fallback.
  if (value == null || !value.isFinite) {
    return isShadow ? const Color(0xFFE3744E) : const Color(0xFFFF9966);
  }

  // 4.5 and above: good.
  if (value >= 4.5) {
    return isShadow ? const Color(0xFF005100) : const Color(0xFF00A651);
  }

  // 3.5 up to 4.5: not bad.
  if (value >= 3.5) {
    return isShadow ? const Color(0xFFE3744E) : const Color(0xFFFF9966);
  }

  // Below 3.5: bad.
  return isShadow ? const Color(0xFFB9719A) : const Color(0xFFFEABDA);
}
