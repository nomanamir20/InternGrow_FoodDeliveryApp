enum CouponType { percentage, fixed }

class Coupon {
  final String code;
  final CouponType type;
  final double value; // percentage (e.g. 15 = 15%) or fixed dollar amount
  final double minOrderValue;
  final String description;

  const Coupon({
    required this.code,
    required this.type,
    required this.value,
    required this.minOrderValue,
    required this.description,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minOrderValue) return 0;
    if (type == CouponType.percentage) {
      return subtotal * (value / 100);
    }
    return value;
  }
}

/// A small set of mock coupon codes for demo purposes — in a real backend
/// these would be validated server-side, but this is realistic enough for
/// a portfolio project's checkout flow.
const List<Coupon> mockCoupons = [
  Coupon(
    code: 'WELCOME10',
    type: CouponType.percentage,
    value: 10,
    minOrderValue: 0,
    description: '10% off your order',
  ),
  Coupon(
    code: 'SAVE5',
    type: CouponType.fixed,
    value: 5,
    minOrderValue: 15,
    description: '\$5 off orders over \$15',
  ),
  Coupon(
    code: 'FEAST20',
    type: CouponType.percentage,
    value: 20,
    minOrderValue: 30,
    description: '20% off orders over \$30',
  ),
];