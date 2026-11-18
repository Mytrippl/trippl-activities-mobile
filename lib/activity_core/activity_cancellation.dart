import '../trippl_activities_mobile.dart';

class ActivityCancellation {
  static ActivityCancellationAssessment assess(
    ActivityCancellationPolicy policy,
    ActivityMoney paid, {
    required DateTime now,
  }) {
    ActivityGuard.record(policy.validate());
    ActivityGuard.record(paid.validate());
    ActivityCancellationAssessment result(
      String state, {
      ActivityMoney? refund,
      ActivityMoney? fee,
      DateTime? deadline,
      List<String> warnings = const [],
    }) => ActivityCancellationAssessment(
      policyId: policy.id,
      evaluatedAt: now,
      state: state,
      refund: refund,
      fee: fee,
      deadlineAt: deadline,
      requiresReview: policy.requiresReview,
      warningCodes: warnings,
    );
    if (!ActivityGuard.fresh(policy.observedAt, policy.expiresAt, now))
      return result('unknown', warnings: ['cancellationDataStale']);
    if (policy.kind == 'unknown')
      return result('unknown', warnings: ['cancellationPolicyUnknown']);
    if (policy.kind == 'nonRefundable')
      return result('nonRefundable', refund: paid.copyWith(amountMinor: 0));
    if (policy.tiers.isEmpty)
      return result('unknown', warnings: ['cancellationDeadlinesMissing']);
    final tiers = policy.tiers.toList()
      ..sort((a, b) => a.cutoffAt.compareTo(b.cutoffAt));
    ActivityGuard.distinct(tiers.map((t) => t.id));
    for (var i = 0; i < tiers.length; i++) {
      final tier = tiers[i];
      ActivityGuard.record(tier.validate());
      if (tier.fee != null) ActivityAmounts.compatible(paid, tier.fee!);
      if (i > 0 &&
          (tier.cutoffAt == tiers[i - 1].cutoffAt ||
              tier.refundBasisPoints > tiers[i - 1].refundBasisPoints))
        throw const FormatException(
          'Cancellation tiers overlap or increase refunds after a cutoff',
        );
    }
    final tier = tiers.where((t) => !now.isAfter(t.cutoffAt)).firstOrNull;
    if (tier == null)
      return result(
        'expired',
        refund: paid.copyWith(amountMinor: 0),
        warnings: ['cancellationDeadlinePassed'],
      );
    var refund = ActivityAmounts.percent(paid, tier.refundBasisPoints);
    final fee = tier.fee;
    if (fee != null)
      refund = refund.copyWith(
        amountMinor: refund.amountMinor > fee.amountMinor
            ? refund.amountMinor - fee.amountMinor
            : 0,
      );
    return result(
      refund.amountMinor == paid.amountMinor
          ? 'free'
          : refund.amountMinor == 0
          ? 'nonRefundable'
          : 'partial',
      refund: refund,
      fee: fee,
      deadline: tier.cutoffAt,
    );
  }

  static bool freeNow(
    ActivityProduct product, {
    required DateTime now,
    required String currency,
  }) {
    final policy = product.cancellation;
    if (policy == null) return false;
    final price = ActivityPricing.startingPrice(product, currency: currency);
    if (price == null) return false;
    final value = assess(policy, price, now: now);
    return value.state == 'free' && !value.requiresReview;
  }

  static String label(
    ActivityCancellationAssessment? value, {
    String locale = 'en',
  }) {
    final tr = locale.startsWith('tr');
    return switch (value?.state) {
      'free' =>
        tr
            ? 'Son tarihe kadar ücretsiz iptal'
            : 'Free cancellation before deadline',
      'partial' => tr ? 'Kısmi iade' : 'Partial refund',
      'nonRefundable' => tr ? 'İade yapılamaz' : 'Non-refundable',
      'expired' => tr ? 'İptal süresi geçti' : 'Cancellation deadline passed',
      _ => tr ? 'İptal koşullarını kontrol edin' : 'Check cancellation terms',
    };
  }
}
