import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/coupon_model.dart';

class CouponState extends Equatable {
  final Coupon? appliedCoupon;
  final String? errorMessage;

  const CouponState({this.appliedCoupon, this.errorMessage});

  @override
  List<Object?> get props => [appliedCoupon, errorMessage];
}

class CouponCubit extends Cubit<CouponState> {
  CouponCubit() : super(const CouponState());

  void applyCoupon(String code, double subtotal) {
    final trimmedCode = code.trim().toUpperCase();

    if (trimmedCode.isEmpty) {
      emit(const CouponState(errorMessage: 'Enter a coupon code'));
      return;
    }

    Coupon? match;
    for (final c in mockCoupons) {
      if (c.code == trimmedCode) {
        match = c;
        break;
      }
    }

    if (match == null) {
      emit(const CouponState(errorMessage: 'Invalid coupon code'));
      return;
    }

    if (subtotal < match.minOrderValue) {
      emit(CouponState(
        errorMessage: 'Minimum order of \$${match.minOrderValue.toStringAsFixed(2)} required for this coupon',
      ));
      return;
    }

    emit(CouponState(appliedCoupon: match));
  }

  void removeCoupon() {
    emit(const CouponState());
  }
}