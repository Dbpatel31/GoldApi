import 'package:get/get.dart';
import 'package:goldapi/models/Player.dart';
import 'package:goldapi/repository/PlayerRepository.dart';
import 'package:goldapi/utils/constant.dart';

class PlayerController extends GetxController{

  var players= <Player>[].obs;
  var isLoading = false.obs;
  var progress= 0.0.obs;
  var page= 1;
  var hasMore= true.obs;
  CanelToken?_canelToken;

  @override
  void onInit() {
    super.onInit();
    fetchPlayers(teamId: 1, season: 2024);
  }
  @override
  void onReady() {
    super.onReady();
    fetchPlayers(teamId: 1, season: 2024); // onReady ma fetch karo
  }

  @override
  void onClose() {
    _canelToken?.cancel();
    super.onClose();
  }


  Future<void>fetchPlayers({
    required int teamId,
    required int season
}) async{
    if(isLoading.value || !hasMore.value) return;

    isLoading.value = true;
    _canelToken = CanelToken();

    try{
      final data= await PlayerRepository.fetchPlayers(
          teamId: teamId,
          season: season,
          page: page,
          perPage: 20,
          cancelToken: _canelToken,
          onProgress: (p) => progress.value =p,
      );
      print("Fetched ${data.length} players from API");

      if(data.isEmpty){
        hasMore.value = false;
      }
      else{
        print("Fetched ${data.length} players");
        players.addAll(data);
        page++;
      }

    } catch(e){
      print("Error fetching players: $e");
    } finally{
      isLoading.value = false;
    }
  }

  void cancelFetch(){
    _canelToken?.cancel();
  }
}