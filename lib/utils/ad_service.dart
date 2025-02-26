import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;
  bool _isInterstitialAdReady = false;

  // Load Banner Ad
  void loadGoogleBannerAd(VoidCallback onAdLoaded) {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test Ad ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onAdLoaded(),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
  }

  // Load Interstitial Ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test Ad ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print("✅ Interstitial Ad Loaded!");
          _interstitialAd = ad;
          _isInterstitialAdReady = true;

          // Set dismiss callback to load a new ad after it's closed
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print("🔄 Interstitial Ad Dismissed, Loading New Ad...");
              _isInterstitialAdReady = false;
              loadInterstitialAd(); // Reload a new ad after it's dismissed
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print("❌ Failed to show interstitial ad: ${error.message}");
              _isInterstitialAdReady = false;
              ad.dispose();
              loadInterstitialAd(); // Reload a new ad if it fails
            },
          );
        },
        onAdFailedToLoad: (error) {
          print("❌ Failed to load interstitial ad: ${error.message}");
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  // Show Interstitial Ad
  void showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialAdReady = false; // Mark it as not ready
    } else {
      print("⚠️ Interstitial Ad Not Ready Yet!");
    }
  }

  void loadNativeAd(VoidCallback onAdLoaded) {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-2562784413680583/3312377865', // TEST ID
      factoryId:
          'listTile', // Make sure this is correctly registered in Android
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print("✅ Native Ad Loaded!");
          _isNativeAdLoaded = true;
          onAdLoaded(); // Trigger UI update
        },
        onAdFailedToLoad: (ad, error) {
          print("❌ Native Ad Failed to Load: ${error.code} - ${error.message}");
          _isNativeAdLoaded = false;
          ad.dispose();
        },
      ),
      request: AdRequest(),
    )..load();
  }

  // Get Banner Ad Widget
  Widget getGoogleBannerAd() {
    return _bannerAd != null
        ? SizedBox(
            height: _bannerAd!.size.height.toDouble(),
            width: _bannerAd!.size.width.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox.shrink();
  }

  Widget getNativeAdWidget() {
    if (_isNativeAdLoaded && _nativeAd != null) {
      return Container(
        height: 120, // Adjust as needed
        padding: EdgeInsets.symmetric(vertical: 10),
        child: AdWidget(ad: _nativeAd!),
      );
    } else {
      return SizedBox.shrink(); // Hide if not loaded
    }
  }
}
