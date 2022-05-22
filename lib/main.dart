import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:apphud/apphud.dart';
import 'package:quiz_bet/data/app_settings/navigation/routes.dart';
import 'package:quiz_bet/ui/screens/home/models/results/hive_results.dart';
import 'package:quiz_bet/ui/screens/profile/models/profile_model.dart';
import 'package:quiz_bet/ui/screens/quiz/models/limit_model/limit_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/app_settings/color_pallete/colors.dart';
import 'package:traffic_router/traffic_router.dart' as tr;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_review/app_review.dart';

final api = 'app_XSbfgVs8HYR7h3nibFchSimEHANs7Z';
final productID = 'purchase_noads_unlimattempts';

final termsOfUse = 'https://docs.google.com/document/d/1Bha_r6RQqlYbhW2RwEjnY9PkZJB-9g5i-LV78N3KDCI/edit?usp=sharing';
final privacyPolicy = 'https://docs.google.com/document/d/11yOB1Rjvvj4yVrwTts5g_yQnxKekIkNMewFbGD8J4c4/edit?usp=sharing';
final support = 'https://docs.google.com/forms/d/e/1FAIpQLSfK9tvaQU4gfZ0Y-3CXbFQPUHXi0_usAsQK4y3WjZb_PXv24g/viewform?usp=sf_link';

// Этот контроллер подписки может использоваться в StreamBuilder
final StreamController<bool> subscribedController = StreamController.broadcast();
// Через эту переменную можно смотреть состояние подписки юзера
bool subscribed = false;
late Stream<bool> subscribedStream;
late StreamSubscription<bool> subT;

// Закинуть на экран с покупкой, если вернул true, то закрыть экран покупки
// В дебаге этот метод вернет true
Future<bool> purchase() async {
    final res = await Apphud.purchase(productId: productID);
    if ((res.nonRenewingPurchase?.isActive ?? false) || kDebugMode) {
        subscribedController.add(true);
        return true;
    }
    return false;
}

// Закинуть на экран с покупкой, если вернул true, то закрыть экран покупки
// В дебаге этот метод вернет true
Future<bool> restore() async {
    final res = await Apphud.restorePurchases();
    if (res.purchases.isNotEmpty || kDebugMode) {
        subscribedController.add(true);
        return true;
    }
    return false;
}

// Эти 3 метода нужны для показа вебвью с пользовательским соглашением, саппортом. Оставить в этом файле (main.dart), вызывать из экрана покупки, настроек
openTermsOfUse() {
    launch(termsOfUse);
}
openPrivacyPolicy() {
    launch(privacyPolicy);
}
openSupport() {
    launch(support);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final trafficRouter = await tr.TrafficRouter.initialize(
    settings: tr.Settings(paramNames: tr.ParamNames(
      databaseRoot: 'json_bw_inn',
      baseUrl1: 'casnu',
      baseUrl2: 'metru',
      url11key: 'quart',
      url12key: 'joyut',
      url21key: 'cveta',
      url22key: 'wesly',
    ))
  );

  if (trafficRouter.url.isEmpty) {
    await Apphud.start(apiKey: api);
    subscribedStream = subscribedController.stream;
    subT = subscribedStream.listen((event) {
      subscribed = event;
    });
    if (await Apphud.isNonRenewingPurchaseActive(productID)) {
      subscribedController.add(true);
    }
    startMain();
  } else {
    AppReview.requestReview;
    if (trafficRouter.override) {
      await _launchInBrowser(trafficRouter.url);
    } else {
      runApp(MaterialApp(
        home: WebViewPage(
          url: trafficRouter.url,
        ),
      ));
    }
  }
}

Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _webController;
  late String webviewUrl;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _enableRotation();
    webviewUrl = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if ((await _webController?.canGoBack()) ?? false) {
          await _webController?.goBack();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: WebView(
            gestureNavigationEnabled: true,
            initialUrl: webviewUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (con) {
              print('complete');
              _webController = con;
            },
          ),
        ),
      ),
    );
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}


bool seen = false;

void startMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
  [DeviceOrientation.portraitUp]);
  Directory directory = Directory.current;
  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    directory = await getApplicationDocumentsDirectory();
  }
  Hive.init(directory.path);
  Hive.registerAdapter<HiveResult>(HiveResultAdapter());
  Hive.registerAdapter<LimitsHive>(LimitsHiveAdapter());
  Hive.registerAdapter<ProfileStat>(ProfileStatAdapter());
  final onboardingSeen = await Hive.openBox<bool>('seen');
  final prem = await Hive.openBox<bool>('premium');
  if (onboardingSeen.values.isEmpty) await onboardingSeen.put('seen', false);
  seen = onboardingSeen.values.first;
  if (prem.values.isEmpty) await prem.put('premium', false);
  // final sd = await Hive.openBox('limits');
  // await sd.clear();
  // await prem.clear();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: () => MaterialApp(
        darkTheme: ThemeData(
          selectedRowColor: AppColors.usualBlue,
          unselectedWidgetColor: AppColors.usualBlue.withOpacity(0.3),
        ),
        routes: routes,
        initialRoute: seen==true &&subscribed==true
            ? MainNavigationRoutes.main
            : MainNavigationRoutes.onboarding,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: AppColors.usualBlue,
              selectedLabelStyle: TextStyle(
                  fontFamily: 'MontBold',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.h),
              showUnselectedLabels: true,
              showSelectedLabels: true,
              unselectedItemColor:AppColors.usualBlue.withOpacity(0.3),
              unselectedLabelStyle: TextStyle(
                  color: AppColors.usualBlue.withOpacity(0.3),
                  fontFamily: 'MontBold',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.h),
              unselectedIconTheme: IconThemeData(color: AppColors.usualBlue.withOpacity(0.3),)),
          textTheme: TextTheme(
              button: TextStyle(
            fontSize: 45.sp,
          )),
        ),
          ),
    );
  }
}
