import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

class CreateDynamicLink {
  static Future<void> initDynamicLinks() async {
    // var data = await FirebaseDynamicLinks.instance.getInitialLink();
    PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    Uri? deepLink = data?.link;

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      deepLink = dynamicLinkData.link;
    }).onError((_) {
      // Handle errors
    });
  }

  static Future<String> createDynamicLink() async {
    try {
      String domainUrl = 'https://azzurri.page.link/influencer';
      final DynamicLinkParameters parameters = DynamicLinkParameters(
          uriPrefix: domainUrl,
          link: Uri.parse('https://www.influencer.com'),
          androidParameters:
              const AndroidParameters(packageName: 'com.azzurri.influencer'),
          iosParameters: const IOSParameters(
              bundleId: 'com.azzurri.influencer', minimumVersion: '2'));
      Uri uri;
      final shortDynamicLink =
          await FirebaseDynamicLinks.instance.buildLink(parameters);
      uri = shortDynamicLink;
      // if (short) {
      //   final shortDynamicLink =
      //       await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      //   uri = shortDynamicLink.shortUrl;
      // } else {
      //   final dynamicLink =
      //       await FirebaseDynamicLinks.instance.buildLink(parameters);
      //   uri = parameters.link;
      // }
      print(uri);
      return uri.toString();
    } catch (_) {
      return '';
    }
  }
}
