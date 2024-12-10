class PaymentResponse {
  final String clientSecret;
  final String paymentIntentId;

  PaymentResponse({required this.clientSecret, required this.paymentIntentId});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      clientSecret: json['clientSecret'],
      paymentIntentId: json['paymentIntentId'],
    );
  }
}