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

dynamic activityAgeBands(dynamic productDetails) {
  if (productDetails == null) return {};

  final pricingTypeRaw = productDetails["pricingType"];
  final isUnit = pricingTypeRaw == "UNIT";

  final List ageBands = productDetails["ageBands"] ?? [];

  Map<String, dynamic> result = {
    "isUnit": isUnit,
    "pricingType": isUnit ? "Unit" : "Person",

    // PER PERSON BANDS
    "adult_visible": false,
    "adult_min": 0,
    "adult_max": 0,
    "adult_startAge": 0,
    "adult_endAge": 0,

    "child_visible": false,
    "child_min": 0,
    "child_max": 0,
    "child_startAge": 0,
    "child_endAge": 0,

    "infant_visible": false,
    "infant_min": 0,
    "infant_max": 0,
    "infant_startAge": 0,
    "infant_endAge": 0,

    "senior_visible": false,
    "senior_min": 0,
    "senior_max": 0,
    "senior_startAge": 0,
    "senior_endAge": 0,

    "youth_visible": false,
    "youth_min": 0,
    "youth_max": 0,
    "youth_startAge": 0,
    "youth_endAge": 0,

    // UNIT
    "traveler_min": 0,
    "traveler_max": 0,
  };

  for (final band in ageBands) {
    final String type = band["ageBand"].toString().toLowerCase();

    if (isUnit && type == "traveler") {
      result["traveler_min"] = band["minTravelersPerBooking"] ?? 0;
      result["traveler_max"] = band["maxTravelersPerBooking"] ?? 0;
      continue;
    }

    if (result.containsKey("${type}_visible")) {
      result["${type}_visible"] = true;
      result["${type}_min"] = band["minTravelersPerBooking"] ?? 0;
      result["${type}_max"] = band["maxTravelersPerBooking"] ?? 0;
      result["${type}_startAge"] = band["startAge"] ?? 0;
      result["${type}_endAge"] = band["endAge"] ?? 0;
    }
  }

  return result;
}
