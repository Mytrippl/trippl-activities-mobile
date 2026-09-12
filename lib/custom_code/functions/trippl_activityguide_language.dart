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

String tripplActivityguideLanguage(dynamic languageCode) {
  if (languageCode == null) return '';

  String code = languageCode.toString().toLowerCase().trim();

  // Normalize underscore formats
  code = code.replaceAll('_', '-');

  switch (code) {
    case 'en':
      code = 'gb';
      break;

    case 'ja':
      code = 'jp';
      break;

    case 'ko':
      code = 'kr';
      break;

    case 'el':
      code = 'gr';
      break;

    case 'cs':
      code = 'cz';
      break;

    case 'sv':
      code = 'se';
      break;

    case 'da':
      code = 'dk';
      break;

    case 'zh-cn':
    case 'cmn':
    case 'wuu':
    case 'hsn':
    case 'mnp':
    case 'hak':
      code = 'cn';
      break;

    case 'zh-tw':
      code = 'tw';
      break;

    case 'yue':
      code = 'hk';
      break;

    case 'jv':
      code = 'id';
      break;

    case 'fil':
      code = 'ph';
      break;

    case 'he':
      code = 'il';
      break;

    case 'fa':
      code = 'ir';
      break;

    case 'ps':
      code = 'af';
      break;

    case 'ku':
      code = 'iq';
      break;

    default:
      // keep original code (works for fr, de, tr, it, es, pt, ru, etc.)
      break;
  }

  return 'https://flagcdn.com/w160/$code.png';
}
