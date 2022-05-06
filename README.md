# islieb

Simple islieb comic reader made with Flutter for Android, iOS and Linux.

The app fetches the RSS feed specified [here](https://gitlab.com/KrilleFear/islieb-comic-reader/-/blob/main/lib/configs/app_constants.dart#L3) and renders the HTML formatted `content` of the RSS `items`. The pubDate format must be valid to be visible. Images and Links must be in correct HTML.

The app stores every request result and caches all loaded images for offline usage. It is able to share the link of `item.content.images.first` assuming that an item normally only has one image.

## How to install

- [Install latest APK from CI](https://gitlab.com/krillefear/islieb-comic-reader/-/jobs/artifacts/main/browse?job=build_apk)

## How to build

Install Flutter from flutter.dev and run it with:

```sh
flutter run
```
