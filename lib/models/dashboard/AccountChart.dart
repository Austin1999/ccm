class AccountChartData {
  AccountChartData({required this.entity, required this.amount, this.currency = 'INR'});
  String entity;
  double amount;
  String currency;

  factory AccountChartData.fromJson(Map<String, dynamic> json) => AccountChartData(
        amount: json["amount"],
        entity: json["entity"],
        currency: json["currency"] ?? '',
      );
}
