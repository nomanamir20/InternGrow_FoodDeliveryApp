import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/address_model.dart';

class AddressState extends Equatable {
  final List<DeliveryAddress> savedAddresses;
  final DeliveryAddress? selectedAddress;

  const AddressState({this.savedAddresses = const [], this.selectedAddress});

  AddressState copyWith({
    List<DeliveryAddress>? savedAddresses,
    DeliveryAddress? selectedAddress,
  }) {
    return AddressState(
      savedAddresses: savedAddresses ?? this.savedAddresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }

  @override
  List<Object?> get props => [savedAddresses, selectedAddress];
}

class AddressCubit extends Cubit<AddressState> {
  static const _prefsKey = 'saved_addresses';

  AddressCubit() : super(const AddressState()) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored != null) {
      final List<dynamic> decoded = jsonDecode(stored);
      final addresses = decoded.map((e) => DeliveryAddress.fromJson(e as Map<String, dynamic>)).toList();
      emit(state.copyWith(savedAddresses: addresses));
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(state.savedAddresses.map((a) => a.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  void addAddress(DeliveryAddress address) {
    emit(state.copyWith(savedAddresses: [...state.savedAddresses, address], selectedAddress: address));
    _saveToPrefs();
  }

  void selectAddress(DeliveryAddress address) {
    emit(state.copyWith(selectedAddress: address));
  }

  void removeAddress(String id) {
    final updated = state.savedAddresses.where((a) => a.id != id).toList();
    emit(state.copyWith(savedAddresses: updated));
    _saveToPrefs();
  }
}