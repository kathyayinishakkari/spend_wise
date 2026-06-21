class Budget {
  const Budget({
    required this.id,
    required this.userId,
    required this.monthKey,
    required this.amount,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String monthKey;
  final double amount;
  final DateTime createdAt;
}