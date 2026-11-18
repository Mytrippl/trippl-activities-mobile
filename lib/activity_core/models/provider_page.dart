// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'attribution.dart';
import 'price_quote.dart';
import 'product.dart';
import 'slot.dart';

class ActivityProviderPage {
  ActivityProviderPage({
    required this.id,
    required this.requestFingerprint,
    required this.observedAt,
    required this.expiresAt,
    List<ActivityProduct> products = const [],
    List<ActivitySlot> slots = const [],
    List<ActivityPriceQuote> quotes = const [],
    List<ActivityAttribution> attributions = const [],
    this.cursor,
    this.complete = false,
    List<String> warningCodes = const [],
  }) : products = List.unmodifiable(products),
       slots = List.unmodifiable(slots),
       quotes = List.unmodifiable(quotes),
       attributions = List.unmodifiable(attributions),
       warningCodes = List.unmodifiable(warningCodes);

  final String id;
  final String requestFingerprint;
  final DateTime observedAt;
  final DateTime expiresAt;
  final List<ActivityProduct> products;
  final List<ActivitySlot> slots;
  final List<ActivityPriceQuote> quotes;
  final List<ActivityAttribution> attributions;
  final String? cursor;
  final bool complete;
  final List<String> warningCodes;

  factory ActivityProviderPage.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "requestFingerprint",
      "observedAt",
      "expiresAt",
      "products",
      "slots",
      "quotes",
      "attributions",
      "cursor",
      "complete",
      "warningCodes",
    });
    final value = ActivityProviderPage(
      id: ActivityCodec.text(json, 'id', required: true)!,
      requestFingerprint: ActivityCodec.text(
        json,
        'requestFingerprint',
        required: true,
      )!,
      observedAt: ActivityCodec.date(json, 'observedAt', required: true)!,
      expiresAt: ActivityCodec.date(json, 'expiresAt', required: true)!,
      products:
          ActivityCodec.list(
            json,
            'products',
            (v) => ActivityProduct.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      slots:
          ActivityCodec.list(
            json,
            'slots',
            (v) => ActivitySlot.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      quotes:
          ActivityCodec.list(
            json,
            'quotes',
            (v) => ActivityPriceQuote.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      attributions:
          ActivityCodec.list(
            json,
            'attributions',
            (v) => ActivityAttribution.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      cursor: ActivityCodec.text(json, 'cursor'),
      complete: ActivityCodec.boolean(json, 'complete') ?? false,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityProviderPage> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityProviderPage.fromJson(ActivityCodec.object(input)),
      );
    } on ActivityValidationException catch (e) {
      return ActivityResult(issues: e.issues);
    } on FormatException {
      return ActivityResult(
        issues: const [
          ActivityIssue(
            'record',
            'format',
            'Activity record has invalid fields or values',
          ),
        ],
      );
    }
  }

  ActivityProviderPage copyWith({
    Set<String> clear = const {},
    String? id,
    String? requestFingerprint,
    DateTime? observedAt,
    DateTime? expiresAt,
    List<ActivityProduct>? products,
    List<ActivitySlot>? slots,
    List<ActivityPriceQuote>? quotes,
    List<ActivityAttribution>? attributions,
    String? cursor,
    bool? complete,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{"cursor"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityProviderPage(
      id: (id ?? this.id),
      requestFingerprint: (requestFingerprint ?? this.requestFingerprint),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      products: (products ?? this.products),
      slots: (slots ?? this.slots),
      quotes: (quotes ?? this.quotes),
      attributions: (attributions ?? this.attributions),
      cursor: clear.contains('cursor') ? null : (cursor ?? this.cursor),
      complete: (complete ?? this.complete),
      warningCodes: (warningCodes ?? this.warningCodes),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (id.trim().isEmpty || id.length > 4000)
        validationIssues.add(
          const ActivityIssue('id', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (requestFingerprint.trim().isEmpty || requestFingerprint.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'requestFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (products.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'products',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < products.length; i++)
        for (final issue in products[i].validate())
          validationIssues.add(
            ActivityIssue(
              'products[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (slots.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'slots',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < slots.length; i++)
        for (final issue in slots[i].validate())
          validationIssues.add(
            ActivityIssue(
              'slots[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (quotes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'quotes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < quotes.length; i++)
        for (final issue in quotes[i].validate())
          validationIssues.add(
            ActivityIssue(
              'quotes[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (attributions.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'attributions',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < attributions.length; i++)
        for (final issue in attributions[i].validate())
          validationIssues.add(
            ActivityIssue(
              'attributions[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (cursor != null) {
      if (cursor!.trim().isEmpty || cursor!.length > 4000)
        validationIssues.add(
          const ActivityIssue('cursor', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (warningCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (warningCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (!expiresAt.isAfter(observedAt) ||
        complete && cursor != null ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(requestFingerprint) ||
        products.map((p) => p.id).toSet().length != products.length ||
        slots.map((s) => s.id).toSet().length != slots.length)
      validationIssues.add(
        const ActivityIssue(
          'record',
          'contract',
          'Record violates its domain constraints',
        ),
      );
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "id": id,
    "requestFingerprint": requestFingerprint,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "products": products.map((item) => item.toJson()).toList(),
    "slots": slots.map((item) => item.toJson()).toList(),
    "quotes": quotes.map((item) => item.toJson()).toList(),
    "attributions": attributions.map((item) => item.toJson()).toList(),
    if (cursor != null) "cursor": cursor,
    "complete": complete,
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityProviderPage &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityProviderPage(redacted)';
}
