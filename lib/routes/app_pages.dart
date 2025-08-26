import 'package:get/get.dart';

import '../view/player_screen.dart';

class Routes{
  static const String player= '/player';
  static const String home= '/home';
}

class AppPages{

  static const initial= Routes.player;

  static final pages=<GetPage>[
    GetPage(
        name: Routes.player,
        page:()=> PlayerScreen()
    ),
    // GetPage(
    //     name: Routes.home,
    //     page: HomeScreen()
    // )
  ];

}