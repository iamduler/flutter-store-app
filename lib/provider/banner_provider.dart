import 'package:flutter_riverpod/legacy.dart';
import 'package:store_app/models/banner.dart';

class BannerNotifier extends StateNotifier<List<BannerModel>> {
  BannerNotifier() : super([]);

  void setBanners(List<BannerModel> banners) {
    state = banners;
  }
}

final bannerProvider = StateNotifierProvider<BannerNotifier, List<BannerModel>>((ref) {
  return BannerNotifier();
});