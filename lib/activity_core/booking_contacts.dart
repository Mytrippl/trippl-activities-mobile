import '../trippl_activities_mobile.dart';

class ActivityContacts {
  static String email(String value) {
    final clean = value.trim();
    if (clean.length > 254 ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(clean) ||
        RegExp(r'[\x00-\x1f<>]').hasMatch(clean))
      throw const FormatException('Enter a bounded email address');
    return clean;
  }

  static String phone(String value) {
    final clean = value.replaceAll(RegExp(r'[ ()-]'), '');
    if (!RegExp(r'^\+[1-9]\d{6,14}$').hasMatch(clean))
      throw const FormatException('Use an international contact phone number');
    return clean;
  }

  static String name(String value) {
    final clean = value.trim();
    if (clean.isEmpty ||
        clean.length > 100 ||
        RegExp(r'[\x00-\x1f<>]').hasMatch(clean))
      throw const FormatException('Enter bounded plain-text name');
    return clean;
  }

  static ActivityBookingContact normalize(
    ActivityBookingContact value, {
    required DateTime now,
  }) {
    ActivityGuard.record(value.validate());
    ActivityBookingGuard.clock(value.updatedAt, now);
    ActivityGuard.language(value.language);
    return value.copyWith(
      email: email(value.email),
      phone: value.phone == null ? null : phone(value.phone!),
      givenName: value.givenName == null ? null : name(value.givenName!),
      familyName: value.familyName == null ? null : name(value.familyName!),
    );
  }

  static List<String> review(
    ActivityBookingContact? value,
    ActivityConfirmationPolicy policy, {
    required DateTime now,
  }) {
    ActivityGuard.record(policy.validate());
    if (value == null) return const ['bookingContactMissing'];
    final normalized = normalize(value, now: now);
    return [
      if (normalized != value) 'contactNeedsNormalization',
      if (policy.requirePhone && value.phone == null) 'contactPhoneRequired',
      if (policy.requireNames &&
          (value.givenName == null || value.familyName == null))
        'contactNamesRequired',
    ];
  }

  static Map<String, Object?> masked(ActivityBookingContact value) {
    final clean = email(value.email), parts = clean.split('@');
    final phoneValue = value.phone;
    return Map.unmodifiable({
      'email': '${parts.first.substring(0, 1)}***@${parts.last}',
      if (phoneValue != null)
        'phone':
            '***${phoneValue.substring(phoneValue.length > 4 ? phoneValue.length - 4 : 0)}',
      'language': value.language,
      'revision': value.revision,
    });
  }
}
