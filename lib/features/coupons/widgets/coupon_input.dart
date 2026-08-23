import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../cubit/coupon_cubit.dart';

class CouponInput extends StatefulWidget {
  final double subtotal;

  const CouponInput({super.key, required this.subtotal});

  @override
  State<CouponInput> createState() => _CouponInputState();
}

class _CouponInputState extends State<CouponInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return BlocBuilder<CouponCubit, CouponState>(
      builder: (context, state) {
        if (state.appliedCoupon != null) {
          final coupon = state.appliedCoupon!;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer, color: AppColors.success, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      Text(coupon.description, style: TextStyle(color: subTextColor, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    context.read<CouponCubit>().removeCoupon();
                    _controller.clear();
                  },
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      isDense: true,
                      prefixIcon: const Icon(Icons.local_offer_outlined, size: 18),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: borderColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.read<CouponCubit>().applyCoupon(_controller.text, widget.subtotal),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(70, 44),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 6),
              Text(state.errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ],
          ],
        );
      },
    );
  }
}