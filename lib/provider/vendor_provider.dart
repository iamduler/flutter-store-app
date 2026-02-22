import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/vendor.dart';

class VendorNotifier extends StateNotifier<List<VendorModel>> {
  VendorNotifier() : super([]);

  void setVendors(List<VendorModel> vendors) {
    state = vendors;
  }
}

final vendorProvider = StateNotifierProvider<VendorNotifier, List<VendorModel>>((ref) {
  return VendorNotifier();
});