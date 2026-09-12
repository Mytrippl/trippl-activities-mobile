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

ActivitySearchType activitySearchType(dynamic type) {
  if (type == null) {
    return ActivitySearchType.Destination;
  }

  final value = type.toString().toLowerCase();

  if (value == 'destination') {
    return ActivitySearchType.Destination;
  }

  if (value == 'attraction') {
    return ActivitySearchType.Attraction;
  }

  if (value == 'product') {
    return ActivitySearchType.Product;
  }

  return ActivitySearchType.Destination;
}
