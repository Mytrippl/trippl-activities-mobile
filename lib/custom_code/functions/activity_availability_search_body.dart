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

dynamic activityAvailabilitySearchBody(
  int? adult,
  int? senior,
  int? youth,
  int? child,
  int? infant,
  int? traveler,
  ActivityPricingType priceType,
  String currency,
  String productCode,
  String productOptionCode,
  DateTime travelDate,
) {
  // Normalize nulls to 0
  adult = adult ?? 0;
  senior = senior ?? 0;
  youth = youth ?? 0;
  child = child ?? 0;
  infant = infant ?? 0;
  traveler = traveler ?? 0;

  List<Map<String, dynamic>> paxMix = [];

  if (priceType == ActivityPricingType.Unit) {
    if (traveler > 0) {
      paxMix.add({
        "ageBand": "TRAVELER",
        "numberOfTravelers": traveler,
      });
    }
  } else {
    if (adult > 0) {
      paxMix.add({
        "ageBand": "ADULT",
        "numberOfTravelers": adult,
      });
    }

    if (senior > 0) {
      paxMix.add({
        "ageBand": "SENIOR",
        "numberOfTravelers": senior,
      });
    }

    if (youth > 0) {
      paxMix.add({
        "ageBand": "YOUTH",
        "numberOfTravelers": youth,
      });
    }

    if (child > 0) {
      paxMix.add({
        "ageBand": "CHILD",
        "numberOfTravelers": child,
      });
    }

    if (infant > 0) {
      paxMix.add({
        "ageBand": "INFANT",
        "numberOfTravelers": infant,
      });
    }
  }

  final formattedDate = "${travelDate.year.toString().padLeft(4, '0')}-"
      "${travelDate.month.toString().padLeft(2, '0')}-"
      "${travelDate.day.toString().padLeft(2, '0')}";

  return {
    "productCode": productCode,
    "productOptionCode": productOptionCode,
    "travelDate": formattedDate,
    "currency": currency,
    "paxMix": paxMix,
  };
}
