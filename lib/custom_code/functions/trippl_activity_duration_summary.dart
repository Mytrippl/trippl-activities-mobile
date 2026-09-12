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

String tripplActivityDurationSummary(
  dynamic durationMinutes,
  String locale,
  int? mode,
) {
  bool isTR = locale == 'tr';

  // If duration is null or invalid
  if (durationMinutes == null) {
    if (mode == 1) {
      return isTR ? 'Süre değişken' : 'Duration varies';
    } else {
      return isTR
          ? 'Detaylar için uygunluğu kontrol et'
          : 'Check availability for schedule details';
    }
  }

  int? minutes;

  if (durationMinutes is int) {
    minutes = durationMinutes;
  } else if (durationMinutes is double) {
    minutes = durationMinutes.toInt();
  } else if (durationMinutes is String) {
    minutes = int.tryParse(durationMinutes);
  }

  if (minutes == null || minutes <= 0) {
    if (mode == 1) {
      return isTR ? 'Süre değişken' : 'Duration varies';
    } else {
      return isTR
          ? 'Detaylar için uygunluğu kontrol et'
          : 'Check availability for schedule details';
    }
  }

  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;

  String title;

  if (isTR) {
    if (hours > 0 && remainingMinutes > 0) {
      title = '$hours saat $remainingMinutes dakika (yaklaşık)';
    } else if (hours > 0) {
      title = '$hours saat (yaklaşık)';
    } else {
      title = '$remainingMinutes dakika (yaklaşık)';
    }
  } else {
    if (hours > 0 && remainingMinutes > 0) {
      title = '$hours hour${hours > 1 ? 's' : ''} '
          '$remainingMinutes minute${remainingMinutes > 1 ? 's' : ''} (approx.)';
    } else if (hours > 0) {
      title = '$hours hour${hours > 1 ? 's' : ''} (approx.)';
    } else {
      title =
          '$remainingMinutes minute${remainingMinutes > 1 ? 's' : ''} (approx.)';
    }
  }

  if (mode == 1) {
    return title;
  } else {
    return isTR
        ? 'Saatleri görmek için uygunluğu kontrol et'
        : 'Check availability to see start times';
  }
}
