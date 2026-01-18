import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webfeed/domain/rss_item.dart';

import 'package:islieb/configs/app_assets.dart';
import 'package:islieb/configs/app_constants.dart';
import 'package:islieb/configs/app_themes.dart';
import 'package:islieb/model/islieb_reader.dart';
import 'package:islieb/utils/localized_date.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController();

  bool displayBackButton = false;

  bool searchMode = false;

  bool get canSwipe =>
      _pageController.hasClients &&
      _pageController.page !=
          (IsliebReader.of(context).rssFeed?.items?.length ?? 0);

  void _updateDisplayBackButton() => setState(() {
    displayBackButton = _pageController.hasClients && _pageController.page != 0;
  });

  void _updateAction() => setState(() {
    IsliebReader.of(context).loadRssFeed();
  });

  @override
  void initState() {
    _pageController.addListener(_updateDisplayBackButton);
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        _updateAction();
      }
      return msg;
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_updateDisplayBackButton);
    super.dispose();
  }

  void _infoButtonAction() => showAboutDialog(
    context: context,
    applicationName: AppConstants.applicationName,
    applicationIcon: Material(
      clipBehavior: Clip.hardEdge,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Image.asset(AppAssets.icon, width: 64, height: 64),
    ),
    children: [
      Html(
        style: AppThemes.htmlStyle,
        onLinkTap: (String? url, Map<String, String> attributes, _) =>
            url == null
            ? null
            : launchUrlString(url, mode: LaunchMode.externalApplication),
        data:
            '<p>Comics and contents by <a href="https://islieb.de">islieb</a>.</p><p>App created with love by <a href="https://krille-chan.github.io/">Krille</a>.</p>',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final isliebReader = IsliebReader.of(context);
    return FutureBuilder(
      future: isliebReader.isLoading,
      builder: (context, snapshot) {
        final items = isliebReader.rssFeed?.items;
        return items == null
            ? Scaffold(
                appBar: AppBar(title: const Text('Lade ...')),
                body: const Center(child: CircularProgressIndicator.adaptive()),
              )
            : Scaffold(
                body: PageView(
                  controller: _pageController,
                  children: [
                    ...items.map((item) {
                      final pubDate = item.pubDate;
                      return Scaffold(
                        appBar: AppBar(
                          title: searchMode
                              ? Autocomplete<(int, RssItem)>(
                                  optionsBuilder: (text) {
                                    final query = text.text.toLowerCase();
                                    return items.where((item) {
                                      final content =
                                          (item.content?.value ?? '') +
                                          (item.title ?? '') +
                                          (item.pubDate?.toIso8601String() ??
                                              '');
                                      return content.toLowerCase().contains(
                                        query,
                                      );
                                    }).indexed;
                                  },
                                  displayStringForOption: (item) =>
                                      item.$2.title ?? 'No title',
                                  onSelected: (item) {
                                    _pageController.jumpToPage(item.$1);
                                    setState(() {
                                      searchMode = false;
                                    });
                                  },
                                  fieldViewBuilder:
                                      (context, textController, focusNode, _) {
                                        return TextField(
                                          autofocus: true,
                                          controller: textController,
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.search_outlined,
                                            ),
                                            suffixIcon: CloseButton(
                                              onPressed: () => setState(() {
                                                searchMode = false;
                                              }),
                                            ),
                                            hintText: MaterialLocalizations.of(
                                              context,
                                            ).searchFieldLabel,
                                            filled: true,
                                            fillColor: Theme.of(
                                              context,
                                            ).colorScheme.surfaceBright,
                                          ),
                                        );
                                      },
                                )
                              : Row(
                                  spacing: 12,
                                  crossAxisAlignment: .center,
                                  children: [
                                    Material(
                                      clipBehavior: Clip.hardEdge,
                                      shape: ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: Image.asset(
                                        AppAssets.icon,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    Text(item.title ?? 'Ohne Titel'),
                                    if (pubDate != null)
                                      Text(
                                        pubDate.getLocalizedDate(context),
                                        style: TextStyle(fontSize: 11),
                                      ),
                                  ],
                                ),
                          actions: searchMode
                              ? null
                              : [
                                  IconButton(
                                    icon: Icon(Icons.search_outlined),
                                    tooltip: MaterialLocalizations.of(
                                      context,
                                    ).searchFieldLabel,
                                    onPressed: () => setState(() {
                                      searchMode = true;
                                    }),
                                  ),
                                ],
                        ),
                        body: RefreshIndicator.adaptive(
                          onRefresh: () => isliebReader.loadRssFeed(),
                          child: ListView(
                            children: [
                              Html(
                                data: item.content?.value ?? '',
                                onLinkTap:
                                    (
                                      String? url,
                                      Map<String, String> attributes,
                                      _,
                                    ) => url == null
                                    ? null
                                    : launchUrlString(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      ),
                                style: AppThemes.htmlStyle,
                                extensions: [
                                  TagExtension(
                                    tagsToExtend: {'img'},
                                    builder: (context) => CachedNetworkImage(
                                      imageUrl: context.attributes['src']!,
                                      fit: BoxFit.fitWidth,
                                      errorWidget: (_, _, _) => const SizedBox(
                                        height: 256,
                                        child: Center(
                                          child: Icon(Icons.wifi_off_outlined),
                                        ),
                                      ),
                                      placeholder: (_, _) => const SizedBox(
                                        height: 256,
                                        child: Center(
                                          child:
                                              CircularProgressIndicator.adaptive(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TagExtension(
                                    tagsToExtend: {'audio', 'video', 'iframe'},
                                    builder: (context) => OutlinedButton(
                                      onPressed: () => launchUrlString(
                                        context.attributes['src']!,
                                        mode: LaunchMode.externalApplication,
                                      ),
                                      child: const Text('Audio abspielen'),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: .center,
                                  spacing: 16,
                                  children: [
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.secondaryContainer,
                                        foregroundColor: Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                      ),
                                      icon: Icon(Icons.adaptive.share_outlined),
                                      onPressed: () => SharePlus.instance.share(
                                        ShareParams(
                                          title:
                                              item.title ??
                                              AppConstants.applicationName,
                                          uri: Uri.tryParse(
                                            (item.content?.images.isNotEmpty ??
                                                        false
                                                    ? item.content?.images.first
                                                    : null) ??
                                                item.link ??
                                                '',
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.tertiaryContainer,
                                        foregroundColor: Theme.of(
                                          context,
                                        ).colorScheme.onTertiaryContainer,
                                      ),
                                      icon: const Icon(Icons.info_outlined),
                                      onPressed: _infoButtonAction,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Scaffold(
                      appBar: AppBar(
                        title: const Text(AppConstants.applicationName),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.info_outlined),
                            onPressed: _infoButtonAction,
                          ),
                        ],
                      ),
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(12),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              AppAssets.icon,
                              width: 128,
                              height: 128,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Huch?! Es wurden keine weiteren Comics gefunden. Schau vielleicht mal auf der Website!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => launchUrlString(
                              AppConstants.website,
                              mode: LaunchMode.externalApplication,
                            ),
                            label: const Text(AppConstants.website),
                            icon: const Icon(Icons.open_in_new),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniCenterDocked,
                floatingActionButton: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      if (displayBackButton)
                        FloatingActionButton(
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).previousPageTooltip,
                          mini: true,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          onPressed: displayBackButton
                              ? () => _pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.bounceInOut,
                                )
                              : null,
                          child: const Icon(Icons.chevron_left),
                        ),
                      Spacer(),
                      FloatingActionButton(
                        mini: true,
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).nextPageTooltip,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        onPressed:
                            (!_pageController.hasClients && items.isNotEmpty) ||
                                canSwipe
                            ? () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.bounceInOut,
                              )
                            : null,
                        child: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
