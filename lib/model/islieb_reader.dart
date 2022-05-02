import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islieb/configs/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

class IsliebReader {
  final Box<String> _rssCache;

  IsliebReader._(Box<String> rssCache) : _rssCache = rssCache;

  static Future<IsliebReader> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>(AppConstants.boxName);
    return IsliebReader._(box)..loadRssFeed();
  }

  static IsliebReader of(BuildContext context) => Provider.of<IsliebReader>(
        context,
        listen: false,
      );

  Widget builder(BuildContext context, Widget? child) => Provider(
        create: (_) => this,
        child: child,
      );

  RssFeed? rssFeed;

  Future? isLoading;

  void loadRssFeed() {
    isLoading = _loadRssFeed();
  }

  Future<void> _loadRssFeed() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.rssUrl));
      final rssString = response.body;
      await _rssCache.put(AppConstants.boxName, rssString);
      rssFeed = RssFeed.parse(rssString);
    } catch (e, s) {
      dev.log('Unable to load rss feed', error: e, stackTrace: s);
      final cachedString = _rssCache.get(AppConstants.boxName);
      if (cachedString == null) return;
      rssFeed = RssFeed.parse(cachedString);
    }
    return;
  }
}
