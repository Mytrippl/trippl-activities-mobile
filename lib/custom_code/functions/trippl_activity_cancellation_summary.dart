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

String tripplActivityCancellationSummary(
  dynamic cancellationType,
  String locale,
  int mode,
) {
  if (cancellationType == null) return '';

  String type = cancellationType.toString().toUpperCase().trim();
  bool isTR = locale == 'tr';

  switch (type) {
    case 'STANDARD':
      if (mode == 1) {
        return isTR ? 'Ücretsiz iptal' : 'Free cancellation';
      } else {
        return isTR
            ? 'Kolayca iptal et, ücretinin tamamını geri al.'
            : 'Cancel easily and receive a full refund.';
      }

    case 'CUSTOM':
      if (mode == 1) {
        return isTR ? 'Esnek iptal' : 'Flexible cancellation';
      } else {
        return isTR
            ? 'İptal zamanına göre iade oranı değişir.'
            : 'Refund varies based on when you cancel.';
      }

    case 'ALL_SALES_FINAL':
      if (mode == 1) {
        return isTR ? 'İade yapılamaz' : 'Non-refundable';
      } else {
        return isTR
            ? 'Satın alındıktan sonra iade mümkün değildir.'
            : 'This booking cannot be refunded after purchase.';
      }

    default:
      return '';
  }
}
