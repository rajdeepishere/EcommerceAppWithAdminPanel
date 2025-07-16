import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../screens/main/main_screen.dart';

class AppPages {
  static const home = '/';

  static final routes = [
    GetPage(name: home, fullscreenDialog: true, page: () => const MainScreen()),
  ];
}
