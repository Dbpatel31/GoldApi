import 'package:get/get.dart';
import 'package:goldapi/controllers/ExpenseController.dart';
import 'package:goldapi/controllers/PlayerController.dart';
import 'package:goldapi/repository/ExpenseRepositiory.dart';
import 'package:goldapi/services/expense_service.dart';
import 'package:goldapi/services/player_service.dart';

class AppBindings extends Bindings{
  static Future<void>initService() async{
    await Get.putAsync(() async => PlayerService());
    Get.lazyPut(()=> PlayerController(),fenix: true);
    await Get.putAsync<HiveService>(() async =>  HiveService().init(),permanent: true);
    Get.lazyPut<ExpenseRepository>(()  {
      final hive = Get.find<HiveService>();
      final repo = ExpenseRepository(hive);
       repo.init();
      return repo;
    });
     Get.lazyPut<ExpenseController>(() {
      final controller = ExpenseController();
       controller.loadAll();
      return controller;
    });
  }
  @override
  void dependencies() {
  }
}